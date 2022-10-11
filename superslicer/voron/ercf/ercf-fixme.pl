#!/usr/bin/perl -i

use strict;
use warnings FATAL => qw(all);

our $DEBUG = $ENV{DEBUG} || 0;

my $header = <<"EOF";

;; ercf-fixme.pl post-processing config:
;;   debug:                    $DEBUG

EOF

if ($DEBUG) {
  foreach my $key (sort keys %ENV) {
    next unless $key =~ m/SLIC3R/;
    $header .= ";; $key => $ENV{$key}\n";
  }
}


while (my $line = <>) {

  if ($header) {
    print $header;
    undef $header;
  }

  if ($line =~ m/^SET_PRESSURE_ADVANCE ADVANCE=0 (EXTRUDER=.*)/) {
    $line = debug_line('SET_PRESSURE_ADVANCE ADVANCE=0', "stripped $1");
  }

  print $line;
}


sub debug_line {

  my ($l, $m) = @_;

  chomp $l;

  if ($DEBUG) {
    no warnings;
    $l .= "  ;; ercf-fixme.pl: $m";
  }

  return "$l\n";
}
