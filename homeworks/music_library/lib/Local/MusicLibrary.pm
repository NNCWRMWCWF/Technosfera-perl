package Local::MusicLibrary;

use strict;
use warnings;
use diagnostics;
use 5.010;
no warnings 'experimental';
use DDP;

=encoding utf8

=head1 NAME

Local::MusicLibrary - core music library module

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

my ($lband, $lyear, $lalbum, $ltrack, $lformat, $count, @sub_choice, @ar, @out_ar, $i, $choice_line, @new_sub_choice, @colums_out, @arg, $j);
$lband=0;
$lyear=0;
$lalbum=0;
$ltrack=0;
$lformat=0;

sub choice{
	$j = 0;
	@sub_choice = @{$_[0]};
	$_ = $_[1];
	if ($_=~ m/.*columns$/) { return; };
	$_ = $_[1];
	while (m/--(\w+)\s([\-\w ,']+?)($|(?= --))/g) {
		$arg[$j] = $1;
		$j++;
		$arg[$j] = $2;
		$j++;
	}
	my $t = 0;
	my $r = 0;
	while ($t < $#arg) {
		given($arg[$t]) {
			when('columns') {
				$r = $t + 1;
				my_print(\@sub_choice, $arg[$r]);
				return;
			}
			when('sort') {
				$r = $t + 1;
				@sub_choice = my_sort(\@sub_choice, $arg[$r]);
				$t += 2;
			}
			when("year") {
				$r = $t + 1; 
				for my $k (0 .. $#sub_choice) {
					if ($sub_choice[$k]->{$arg[$t]}+0 == $arg[$r]+0) { push @new_sub_choice, $sub_choice[$k]; }
				}
				@sub_choice = @new_sub_choice;
				$t += 2;
				@new_sub_choice = qw();
			}
			when(m/(band|track|format|album)/) {
				$r = $t + 1; 
				for my $k (0 .. $#sub_choice) {
					if ($sub_choice[$k]->{$arg[$t]} eq $arg[$r]) { push @new_sub_choice, $sub_choice[$k]; }
				}
				@sub_choice = @new_sub_choice;
				$t+=2;
				@new_sub_choice = qw();
			}
			default{}
		}
	}
	if (!@sub_choice) { return; }
	my_print(\@sub_choice);
}

sub my_sort{
	my @ar_sort = @{$_[0]};
	my $param = $_[1];
	foreach my $k (@ar_sort) { push (@ar, $k->{$param}); }
	if ($param eq "year") { 
		for my $k (0..$#ar) { $k += 0; }
		@ar = sort {$a <=> $b} @ar;
		while ($#ar!=-1) {
			foreach my $k (@ar_sort){
				if ($k->{$param}+0 == $ar[0]) {
					push(@out_ar, $k); 
					shift @ar; 
					last;
				}
			}
		}
	} else {
			@ar = sort @ar;
			while ($#ar!=-1) {
				foreach my $k (@ar_sort){
					if ($k->{$param} eq $ar[0]) {
						push(@out_ar, $k); 
						shift @ar; 
						last;
					}
				}
			}
		}
	return @out_ar;
}

sub my_print{
	my @sort_ar = @{$_[0]};
	my $print_param = $_[1];
	foreach my $k (@sort_ar){
		if (length %$k{band}>$lband) { $lband=length %$k{band}; }
	}
	foreach my $k(@sort_ar) {
		if (length %$k{year}>$lyear) { $lyear=length %$k{year}; }
	}
	foreach my $k(@sort_ar) {
		if (length %$k{album}>$lalbum) { $lalbum=length %$k{album}; }
	}
	foreach my $k(@sort_ar) {
		if (length %$k{track}>$ltrack) { $ltrack=length %$k{track}; }
	}
	foreach my $k(@sort_ar) {
		if (length %$k{format}>$lformat) { $lformat=length %$k{format}; }
	}
	$i = 0;
	$count = @sort_ar;
	if ($print_param) { 
		@colums_out = split(",",$print_param); 
	} else { 
		@colums_out = qw(band year album track format);
	}
	my $sum;
	for my $j(@colums_out){
		given ($j){
			when("track"){ $sum+=$ltrack; }
			when("band"){ $sum+=$lband; }
			when("format"){ $sum+=$lformat; }
			when("year"){ $sum+=$lyear; }
			when("album"){ $sum+=$lalbum; }
			default{}
		}
	}
	print "/".("-" x ($sum+@colums_out*3-1))."\\\n";
	foreach my $k (@sort_ar){
		my $c = 0;
			for my $j(@colums_out){
				given ($j){
					when("track") { if ($c == 0) { printf "| %${ltrack}s |", $k->{track}; $c++; } else { printf " %${ltrack}s |", %$k{track}.""; }}
					when("band") { if ($c == 0) { printf "| %${lband}s |", $k->{band}; $c++; } else { printf " %${lband}s |", %$k{band}.""; }}
					when("format") { if ($c == 0) { printf "| %${lformat}s |", $k->{format}; $c++; } else { printf " %${lformat}s |", %$k{format}.""; }}
					when("year") { if ($c == 0) { printf "| %${lyear}s |", $k->{year}; $c++; } else { printf " %${lyear}s |", %$k{year}.""; }}
					when("album") { if ($c == 0) { printf "| %${lalbum}s |", $k->{album}; $c++; } else { printf " %${lalbum}s |", %$k{album}.""; }}
					default{}
				}
			}
		print "\n";
		$i+=1;
		if ($i==$count) { last; }
		$c = 0;
		for my $j(@colums_out){
			given ($j){
				when("track") { 
					if ($c == 0) { 
						print "|".("-" x ($ltrack+2)); $c++; 
					} elsif ($c==$#colums_out) { 
						print "+".("-" x ($ltrack+2))."|"; 
					} else { print "+".("-" x ($ltrack+2));$c++; }
				}
				when("band") {
					if ($c == 0) { 
						print "|".("-" x ($lband+2)); $c++; 
					} elsif ($c==$#colums_out){ 
						print "+".("-" x ($lband+2))."|"; 
					} else { print "+".("-" x ($lband+2));$c++; }}
				when("format") {
					if ($c == 0) { 
						print "|".("-" x ($lformat+2)); $c++;
					} elsif ($c==$#colums_out){ 
						print "+".("-" x ($lformat+2))."|";
					} else { print "+".("-" x ($lformat+2));$c++; }}
				when("year") { 
					if ($c == 0) { 
						print "|".("-" x ($lyear+2)); $c++; 
					} elsif ($c==$#colums_out) {
						print "+".("-" x ($lyear+2))."|"; 
					} else { print "+".("-" x ($lyear+2));$c++; }}
				when("album") { 
					if ($c == 0) { 
						print "|".("-" x ($lalbum+2)); $c++; 
					} elsif ($c==$#colums_out){ 
						print "+".("-" x ($lalbum+2))."|"; 
					} else { print "+".("-" x ($lalbum+2));$c++; }}
				default{}
			}
		}
		print "\n";
	}
	print "\\".("-" x ($sum+@colums_out*3-1))."/\n";
}

1;
