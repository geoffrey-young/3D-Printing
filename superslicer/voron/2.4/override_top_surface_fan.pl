#!/usr/bin/perl -i

use strict;
use warnings FATAL => qw(all);

# post-processing script for setting the fan speed for top layer movements
# (and restoring prior fan speed on the next movement type).
#
# defaults to 10% for ABS only, but configurable - just adjust $MAX_PERCENTS below
#
# see
#
#  https://manual.slic3r.org/advanced/post-processing
#
# for details on how to set it up

my $MAX_PERCENTS = {
  ABS => 10,
};



my $filament = $ENV{SLIC3R_FILAMENT_TYPE} || 'unknown';
my $filament_percent = $MAX_PERCENTS->{$filament};
my $top_speed = undef;

$top_speed = speed_from_percent($filament_percent) if $filament_percent;

my $last_fan_speed = 0;
my $restore = 0;

while (my $line = <>) {

  if (defined $top_speed) {

    if ($line =~ m/M106 S([\d.]+)/ || $line =~ m/M107/) {
      $last_fan_speed = $1 || 0;
      if ($restore) {
        chomp $line;
        $line .= "  ; FAN OVERRIDE: no restore required\n"; 
        $line .= "M118 fan restored via slicer\n";
        undef $restore;
      }
    }
    elsif ($line =~ m/;TYPE:Top solid infill/) {
      # lower fan if required
      if ($last_fan_speed <= $top_speed) {
        # do nothing
      }
      else {
        print "M106 S${top_speed}  ; FAN OVERRIDE: ${filament_percent}%\n";
        print "M118 limiting 'Top solid infill' fan speed to ${filament_percent}% (was S${last_fan_speed})\n";
        $restore++;
      }
    }
    elsif ($line =~ m/;TYPE:(.*)/ && $restore) {
      # restore last fan speed
      print "M106 S${last_fan_speed}  ; FAN OVERRIDE: restored \n";
      my $percent = percent_from_speed($last_fan_speed);
      print "M118 fan restored to ${percent}% (S${last_fan_speed}) for '$1'\n";
      undef $restore;
    }
  }

  print $line;
}

sub percent_from_speed {

  my $speed = shift;

  return int($speed/255 * 100);
}

sub speed_from_percent {

  my $percent = shift;

  return 255 * ($percent/100);
}
