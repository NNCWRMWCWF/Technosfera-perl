package Local::Print;

use strict;
use warnings;
use diagnostics;
use DDP;

my (%lhash, @columns_out, $sum, @output, $delit);

sub my_print{
	my @sort_ar = @{$_[0]};
	my $print_param = $_[1];
	my @default_out = qw(band year album track format);
	for my $i (@default_out) {$lhash{$i} = 0;}
	foreach my $k (@sort_ar) {
		foreach my $key (keys %lhash) {
			if ( length %$k{$key} > $lhash{$key} ) { $lhash{$key} = length %$k{$key} }
		}
	}
	if ($print_param) { 
		@columns_out = split(",",$print_param); 
	} else { 
		@columns_out = @default_out;
	}
	for my $j (@columns_out) { $sum += $lhash{$j}; }
	my $c = 0;
	for my $j(@columns_out) {
					if ($c == 0) { $delit = "|".("-" x ( $lhash{$j} + 2 )); $c++;
					} else { $delit.= "+".( "-" x ($lhash{$j} + 2 )); }
		}
	$delit .="|\n";
	foreach my $k (@sort_ar) {
		my $line = "|";
		for my $j(@columns_out) { $line .= sprintf " %${lhash{$j}}s |", $k->{$j}; }
		push @output, $line."\n";
		}
	print "/".("-" x ($sum+@columns_out*3-1))."\\\n";
	print join $delit, @output;	
	print "\\".( "-" x ($sum+@columns_out*3-1) )."/\n";
}

1;