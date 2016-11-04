#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use DDP;
use Getopt::Long;
use lib "$FindBin::Bin/../lib";
use Local::MusicLibrary;
use Local::Print;


my ($line, @ar, @out_ar, %hash_arg);
my $i = 0;

while(<STDIN>) {
    chomp;
    if ( $_ =~ m{^\. /(?<band>[^/]+)/(?<year>\d+)\s+ - \s+(?<album>[^/]+)/(?<track>.+)\.(?<format>[^\.]+)$}x ) {
	@ar[$i] = {%+};
	$i++;
} else { @ar = qw(); last; } }

#my %hash_arg = ();
GetOptions(\%hash_arg, 'band=s', 'year=s', 'album=s', 'track=s', 'format=s', 'sort=s', 'columns|column=s');
if (%hash_arg && @ar) {
	Local::MusicLibrary::choice(\@ar, \%hash_arg);
} elsif (@ar) {
	Local::Print::my_print(\@ar);
	}