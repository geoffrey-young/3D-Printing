#!/usr/bin/perl -i

# speed up travel moves by raising acceleration then setting it back before the next extrusion
#
# based on # @Stephan V2.051's SuperSlicer travel post-processing script
#
#  https://github.com/Stephan3/Schnitzelslicerrepo/blob/master/superslicer/pp.py
#
# but moved to perl, stripped of extrusion modifications, and modified to work with
#
#  https://github.com/geoffrey-young/3D-Printing/blob/main/klipper/voron/2.4/macros/PRINT_TYPE_ACCEL.cfg
#
# PRINT_TYPE_ACCEL.cfg regex and replacements are the default, but you can use whatever
# search/replace strings you like without alter the base code

use strict;
use warnings FATAL => qw(all);

# the string to match for, based on other slicer gcode rules
our $CURRENT_VELOCITY_REGEX = qr/^SET_PRINT_TYPE_ACCEL/;

# the travel override
our $OVERRIDE_TRAVEL_VELOCITY = "SET_PRINT_TYPE_ACCEL TYPE=Travel";


my $max_travel_speed = ($ENV{SLIC3R_TRAVEL_SPEED} || 0) * 60;  # way easier than slurping the entire file

my $last;
my $STATE = 0;


use constant STATE_CLEAN => 1;
use constant STATE_DIRTY => 2;
use constant STATE_KNOWN => STATE_CLEAN | STATE_DIRTY;

sub CLEAN { $STATE & STATE_CLEAN };
sub DIRTY { $STATE & STATE_DIRTY };
sub KNOWN { $STATE & STATE_KNOWN };

sub MARK_CLEAN { $STATE = STATE_CLEAN };
sub MARK_DIRTY { $STATE = STATE_DIRTY };
sub MARK_KNOWN { $STATE = STATE_KNOWN };


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

    if (DIRTY) {

        chomp $line;

        $line = "$line  ;; override_travel_velocity.pl: travel velocity self-restored\n";
    }

    MARK_CLEAN;
  }
  elsif (KNOWN) {

    if ($line =~ m/G1 X\d+.\d+ Y\d+.\d+ F${max_travel_speed}/) {

      # found max travel move...

      if (DIRTY) {
        # already in an override...
      }
      else {
        $line = "$OVERRIDE_TRAVEL_VELOCITY  ;; override_travel_velocity.pl: travel velocity override\n$line";

        MARK_DIRTY;
      }
    }

    if ($line =~ m/G1 F\d+/) {

      # found a non-max travel move...

      if (DIRTY) {

        # restore last accel

        chomp $last;

        $line = "$last  ;; override_travel_velocity.pl: travel velocity restored\n$line";

        MARK_CLEAN;
      }
    }
  }

  print $line;
}
