#!/usr/bin/perl -i

# adjust/enforce fan rules:
#
#  - overhangs use same fan settings as bridges
#  - use bridge/overhang and external perimeter fan speed at all layers, overriding disable_fan_first_layers
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


my $min_fan_speed = (($ENV{SLIC3R_MIN_FAN_SPEED} || 35) / 100) * 255;
my $bridge_fan_speed = (($ENV{SLIC3R_BRIDGE_FAN_SPEED} / 100) || 1) * 255;
my $external_perimeter_fan_speed = (($ENV{SLIC3R_EXTERNAL_PERIMETER_FAN_SPEED} / 100) * 255) || $min_fan_speed;


my $last_fan;
my $last_type;
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

;; enforce_bridge_fan.pl post-processing config:
;;   min_fan_speed: $min_fan_speed
;;   bridge_fan_speed: $bridge_fan_speed
;;   external_perimeter_fan_speed: $external_perimeter_fan_speed

EOF

while (my $line = <>) {

  if ($header) {
    print $header;
    undef $header;
  }

  if ($line =~ m/^M10[67]\s+/ ) {

    if (DIRTY) {
      next;
    }
    else {
      $last_fan = $line;
      MARK_CLEAN;
    }
  }
  elsif (KNOWN) {

    if ($line =~ m/^;TYPE:(Overhang|Bridge|External)/) {

      my $type = $1;

      if (DIRTY && ($type eq $last_type || $external_perimeter_fan_speed eq $bridge_fan_speed)) {
        # already in an override...
      }
      else {
        my $fan = ($type =~ m/External/ ? $external_perimeter_fan_speed : $bridge_fan_speed);

        $line = "M106 S${fan}  ;; enforce_bridge_fan.pl: $type override\n$line";

        MARK_DIRTY;
      }
      $last_type = $type;
    }
    elsif ($line =~ m/^;TYPE:/) {

      if (DIRTY) {

        chomp $last_fan;

        $line = "$last_fan  ;; enforce_bridge_fan.pl: fan restored\n$line";

        MARK_CLEAN;
      }
    }
  }

  print $line;
}
