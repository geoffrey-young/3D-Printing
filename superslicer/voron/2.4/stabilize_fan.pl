#!/usr/bin/perl -i

use strict;
use warnings FATAL => qw(all);

use Data::Dumper;

# for good looking, strong parts there are only 3 fan speeds that matter:

my $min_fan_speed                = (($ENV{SLIC3R_MIN_FAN_SPEED} / 100) || 1) * 255;
my $bridge_fan_speed             = (($ENV{SLIC3R_BRIDGE_FAN_SPEED} / 100) || 1) * 255;
my $top_fan_speed                = (($ENV{SLIC3R_TOP_FAN_SPEED} / 100) || 1) * 255;

# align the different features with one of these three fan settings
my $map = {
  'Bridge infill'          => $bridge_fan_speed,  # bridge and overhangs should always be the same
  'Overhang perimeter'     => $bridge_fan_speed,

  'External perimeter'     => $bridge_fan_speed,  # good looking outer walls require extra cooling, but
  'Internal perimeter'     => $bridge_fan_speed,  # if you just adjust one wall you get pulls and twists

  'Top solid infill'       => $top_fan_speed,     # top layer does top layer

  'Internal bridge infill' => $min_fan_speed,     # everything else gets a lower speed for better bonding
  'Internal infill'        => $min_fan_speed,
  'Skirt'                  => $min_fan_speed,
  'Solid infill'           => $min_fan_speed,

  'Gap fill'               => undef,              # except gap fill, which doesn't initiate a change
};

# the rest is pretty simple... well, almost.
my $disable_fan_first_layers = $ENV{SLIC3R_DISABLE_FAN_FIRST_LAYERS} || 0;   # respect this
my $full_fan_speed_layer = $ENV{SLIC3R_FULL_FAN_SPEED_LAYER} || 0;           # enforce this across the board - if you have bridges in these layers you're out of luck

my $steps = $full_fan_speed_layer - $disable_fan_first_layers;

$steps = 1 if $steps <= 0;

my $factor = 1 / $steps;


my $header = <<"EOF";

;; stabilize_fan.pl post-processing config:
;;   min_fan_speed:            $min_fan_speed
;;   bridge_fan_speed:         $bridge_fan_speed
;;   top_fan_speed:            $top_fan_speed
;;   disable_fan_first_layers: $disable_fan_first_layers
;;   full_fan_speed_layer:     $full_fan_speed_layer
;;   steps:                    $steps
;;   steps factor:             $factor

EOF


my $layer = 0;
my $fan_speed;
my $last_speed = 0;
my $last_type = 'initial';

my $length = 0;

my $stats = { max => 0, changes => 0, total => 0, average => 0, };


while (my $line = <>) {

  if ($header) {
    print $header;
    undef $header;
  }

  if ($line =~ m/^;LAYER_CHANGE/) {

    $layer++;

    chomp $line;

    $line .= "  ; stabilize_fan.pl: starting layer $layer\n";
  }
  elsif ($line =~ m/^M106\s+(S\d+)?/ ) {

    # complete override - skip printing entirely
    next;

    #chomp $line;
    #$line = "; $line  ;; stabilize_fan.pl: slicer fan ignored\n";
  }
  elsif ($line =~ m/^;TYPE:([\w\s]+)\n/ ) {

    my $type = $1;

    my $speed = proper_speed($type, $layer);

    if ($speed) {

      if ($last_speed && $last_speed == $speed) {
        #$line .= "; M106 S${speed}  ;; stabilize_fan.pl: $last_type, $last_speed == $type, $speed - skipping\n";
      }
      else {

        # insert proper speed

        my $pretty = sprintf("%0.1f", $length);

        $line .= "M106 S${speed}  ;; stabilize_fan.pl: $last_type, $last_speed -> $type, $speed after ${pretty}mm at layer $layer\n";

        calculate_stats();

        $length = 0;
      }

      $last_speed = $speed;
      $last_type = $type;
    }
    else {

      #$line .= ";; stabilize_fan.pl: maintaining $last_speed for $last_type -> $type\n"
      #  unless $last_type eq 'initial';
    }
  }
  elsif ($line =~ m/G1 X[\d.]+ Y[\d.]+ E([\d.]+)/) {
    $length += $1;  # just for stats
  }

  print $line;
}


sub proper_speed {
  my ($type, $layer) = @_;

  # Gap fill (and other undefs) don't change anything
  return unless $map->{$type};

  if ($layer <= $disable_fan_first_layers) {
    # nothing to do
    return;
  }
  
  if ($layer >= $full_fan_speed_layer) {
    return $map->{$type};
  }

  # we're in the middle ground between zero fan and 100% fan

  if ($type =~ m/perimeter/) {
    # make these outer walls constant across the print,
    # since not doing so will make the outside look banded
    return $map->{$type};
  }

  # fan step calculations
  # the result isn't identical to superslicer, but it's close enough
  my $multiplier = $layer - $disable_fan_first_layers;

  return sprintf('%.0f', $min_fan_speed * $factor * $multiplier);
}

sub calculate_stats {
  $stats->{changes}++;
  $stats->{max} = $length > $stats->{max} ? $length : $stats->{max};
  $stats->{min} = defined $stats->{min} ? ($length < $stats->{min} ? $length : $stats->{min}) : $length;
  $stats->{total} += $length;
  $stats->{average} = $stats->{total}/$stats->{changes};
}

warn Dumper($stats);

