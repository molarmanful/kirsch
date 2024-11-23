use strict;
use warnings;

my $s = 1;
my $c = 0;
while ( my $l = <STDIN> ) {
  if ( $l =~ /^STARTCHAR U\+\w{5,}/ ) {
    $s = 0;
  }
  print $l if $s;
  if ( $l =~ /^ENDCHAR$/ ) {
    $s = 1;
  }
}
