#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use DDP;
use Getopt::Long;
use lib "$FindBin::Bin/../lib";
use Local::MusicLibrary;
use Local::Print;


my ($ref, $line, @ar, @out_ar, %hash_arg);

while(<STDIN>) {
    if ( $_ =~ m{^\. /(?<band>[^/]+)/(?<year>\d+)\s+ - \s+(?<album>[^/]+)/(?<track>.+)\.(?<format>[^\.]+)\n}x ) {
	push @ar, {%+};
} else { @ar = qw(); last; } }
GetOptions(\%hash_arg, 'band=s', 'year=s', 'album=s', 'track=s', 'format=s', 'sort=s', 'columns|column=s');
if (%hash_arg && @ar) {
	$ref = Local::MusicLibrary::choice(\@ar, \%hash_arg);
	if ($ref) { 
	$#{$ref} == 0 ? Local::Print::my_print($ref -> [0]) : Local::Print::my_print($ref -> [0], $ref -> [1]);}
} elsif (@ar) {
	Local::Print::my_print(\@ar);
	}
	