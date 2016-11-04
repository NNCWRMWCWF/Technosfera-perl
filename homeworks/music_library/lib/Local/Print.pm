package Local::Print;

use strict;
use warnings;
use diagnostics;
use DDP;

my ($i, $count, @columns_out);

sub my_print{
	my @sort_ar = @{$_[0]};
	my $print_param = $_[1];
	my %lhash = ("band", 0 , "year", 0 , "album", 0, "track", 0, "format", 0);
	foreach my $k (@sort_ar) {
		foreach my $key (keys %lhash) {
			if ( length %$k{$key} > $lhash{$key} ) { $lhash{$key} = length %$k{$key} }
		}
	}
	$i = 0;
	$count = @sort_ar;
	if ($print_param) { 
		@columns_out = split(",",$print_param); 
	} else { 
		@columns_out = qw(band year album track format);
	}
	my $sum;
	for my $j (@columns_out) { $sum += $lhash{$j}; }
	print "/".("-" x ($sum+@columns_out*3-1))."\\\n";
	foreach my $k (@sort_ar) {
		my $c = 0;	
		for my $j(@columns_out) {
			 if ($c == 0) { printf "| %${lhash{$j}}s |", $k->{$j}; $c++; } else { printf " %${lhash{$j}}s |", $k->{$j}; }
			}
		print "\n";
		$i+=1;
		if ($i==$count) { last; }
		$c = 0;
		for my $j(@columns_out){
					if (($c == 0) & ($#columns_out == 0)) { 
						print "|".("-" x ( $lhash{$j} + 2 )."|" ); last;}
					if ($c == 0) { 
						print "|".("-" x ( $lhash{$j} + 2 ) ); $c++; 
					} elsif ($c == $#columns_out) { 
						print "+".( "-" x ($lhash{$j}+2) )."|"; 
					} else { print "+".( "-" x ($lhash{$j} + 2) );$c++; }
				}
		print "\n";
	}
	print "\\".( "-" x ($sum+@columns_out*3-1) )."/\n";
}

1;