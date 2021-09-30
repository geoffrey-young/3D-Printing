#!/usr/bin/perl -i

use strict;
use warnings FATAL => qw(all);

# override travel moves
# based on # @Stephan V2.051's SuperSlicer travel post-processing script
#
#  https://github.com/Stephan3/Schnitzelslicerrepo/blob/master/superslicer/pp.py
#
# but moved to perl, and modified to work with PRINT_TYPE_ACCEL.cfg
#
#  https://github.com/geoffrey-young/3D-Printing/blob/main/klipper/voron/2.4/macros/PRINT_TYPE_ACCEL.cfg

# the string to match for, based on other slicer gcode rules
our $CURRENT_VELOCITY_REGEX = qr/^SET_PRINT_TYPE_ACCEL/;

# the travel override
our $OVERRIDE_TRAVEL_VELOCITY = "SET_PRINT_TYPE_ACCEL TYPE=Travel";


my $max_travel_speed = ($ENV{SLIC3R_TRAVEL_SPEED} || 0) * 60;

my $last;
my $restore;

my $header = <<"EOF";

;; override_travel_velocity.pl post-processing config:
;;   CURRENT_VELOCITY_REGEX: $CURRENT_VELOCITY_REGEX
;;   OVERRIDE_TRAVEL_VELOCITY: $OVERRIDE_TRAVEL_VELOCITY
;;   Calculated max travel speed: F${max_travel_speed}

EOF

while (my $line = <>) {

  if ($header) {
    print $header;
    undef $header;
  }

  if ($line =~ $CURRENT_VELOCITY_REGEX) {

    # store prior accel override
    $last = $line;

    undef $restore;
  }
  elsif ($last && $line =~ m/G1 X\d+.\d+ Y\d+.\d+ F${max_travel_speed}/) {
    # found travel move - set override
    $line = "$OVERRIDE_TRAVEL_VELOCITY  ; travel velocity override\n$line";
    $restore++;
  }
  elsif ($last && $line =~ m/G1 F\d+/) {
    if ($restore) {
      # restore last accel
      chomp $last;
      $line = "$last  ; travel velocity restored\n$line";
      undef $restore;
    }
    else {
      chomp $line;
      $line .= "  ; travel velocity self-restored\n";
    }
  }

  print $line;
}
