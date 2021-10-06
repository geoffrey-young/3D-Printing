#!/usr/bin/perl -i

# adjust/enforce fan rules:
#
#  - overhangs use same fan settings as bridges
#  - use bridge/overhang fan speed at all layers, overriding disable_fan_first_layers
#
# this script was the result of experimentations on the Clockwork Afterburner part
#
#   Direct_Feed/extruder_body.stl
#
# where I was irked that the bridging on behind the logo on layer 3 didn't get bridge fan speeds applied
# if under the control of disable_fan_first_layers or full_fan_speed_layer.  then I noticed that the
# overhangs higher up also didn't use the bridging speed like the superslicer help says it does...

use strict;
use warnings FATAL => qw(all);


my $bridge_fan_speed = (($ENV{SLIC3R_BRIDGE_FAN_SPEED} / 100) || 1) * 255;


my $last;
my $moves = 0;
my $STATE = 0;

use constant STATE_CLEAN => 1;
use constant STATE_DIRTY => 2;
use constant STATE_BRIDGE => 4;
use constant STATE_FAN_OFF => 8;
use constant STATE_KNOWN => STATE_CLEAN | STATE_DIRTY | STATE_BRIDGE | STATE_FAN_OFF;

sub CLEAN { $STATE & STATE_CLEAN };
sub DIRTY { $STATE & STATE_DIRTY };
sub BRIDGE { $STATE & STATE_BRIDGE };
sub FAN_OFF { $STATE & STATE_FAN_OFF };
sub KNOWN { $STATE & STATE_KNOWN };

sub MARK_CLEAN { $STATE = STATE_CLEAN };
sub MARK_DIRTY { $STATE |= STATE_DIRTY };
sub MARK_BRIDGE { $STATE |= STATE_BRIDGE };
sub MARK_FAN_OFF { $STATE |= STATE_FAN_OFF };
sub MARK_KNOWN { $STATE = STATE_KNOWN };


my $header = <<"EOF";

;; enforce_bridge_fan.pl post-processing config:
;;   bridge_fan_speed: $bridge_fan_speed

EOF

while (my $line = <>) {

  if ($header) {
    print $header;
    undef $header;
  }

  if ($line =~ m/^M10[67]\s+(S\d+)?/ ) {

    my $speed = $1;

    if (DIRTY) {
      chomp $line;

      $line .= "  ; enforce_bridge_fan.pl: fan speed auto-restored\n";
    }
    MARK_CLEAN;

    if ($speed && $speed eq "S${bridge_fan_speed}") {
      # slicer setting to bridge fan speed (for some reason, not necessarily a bridge)
      # regardless of reason there's no reason to change for an upcoming bridge or overhang

      MARK_BRIDGE;
    }
    elsif ($line =~ m/M107/) {
      MARK_FAN_OFF;
    }
    
    $last = $line;
  }
  elsif (KNOWN) {

    if ($line =~ m/^;TYPE:(Overhang|Bridge)/) {

      my $type = $1;

      if (DIRTY) {
        # already in an override...
      }
      elsif (BRIDGE) {
        # current fan speed is equal to bridge fan speed - nothing to do
      }
      else {

        if ($type eq 'Overhang' && (FAN_OFF || $moves < 50)) {
          # don't override overhangs when the fan is off or we're jumping between overhangs and perimeters
          # this saves some crazy fan switching
        }
        else {
          $line = "M106 S${bridge_fan_speed}  ;; enforce_bridge_fan.pl: $type override\n$line";

          MARK_DIRTY;
        }
      }
      
      MARK_BRIDGE;

      undef $moves;
    }
    elsif ($line =~ m/^;TYPE:/) {

      if (DIRTY) {

        chomp $last;

        $line = "$last  ;; enforce_bridge_fan.pl: fan speed restored\n$line";

        MARK_CLEAN;
      }

      undef $moves;
    }

    if ($line =~ m/G1 X/) {
      # count moves
      $moves++;
    }
  }

  print $line;
}
