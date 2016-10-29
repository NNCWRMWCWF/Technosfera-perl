#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use DDP;
use lib "$FindBin::Bin/../lib";
use Local::MusicLibrary qw/choice my_sort my_print/;


my (%hash, $line, @ar, @out_ar);
my $i = 0;

while(<STDIN>) {
    chomp;
    $_ =~ m{^\. /(?<band>[^/]+)/(?<year>\d+)\s+ - \s+(?<album>[^/]+)/(?<track>.+)\.(?<format>[^\.]+)$}x;
    $hash{$i} = {%+};
	@ar[$i] = {%+};
	$i++;
}

if (@ARGV) {
	$line = join " ", @ARGV;
	chomp $line;
	Local::MusicLibrary::choice(\@ar, $line);
}
else {
	Local::MusicLibrary::my_print(\@ar);
}