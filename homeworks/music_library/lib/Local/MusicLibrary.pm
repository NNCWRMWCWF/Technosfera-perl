package Local::MusicLibrary;

use strict;
use warnings;
use diagnostics;
use DDP;
use Local::Print;

=encoding utf8

=head1 NAME

Local::MusicLibrary - core music library module

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

my (@sub_choice, $str_filt, @ar, @out_ar, @arg, $j, %arg, @print_ar);

sub choice {
	$j = 0;
	@sub_choice = @{$_[0]};
	if ( @sub_choice == 0 ) { return; }
	%arg = %{$_[1]};
	$str_filt = "band|track|format|album";
		for my $key (keys %arg) {
			if ($key =~ m/$str_filt/) { 
				@sub_choice = grep {$_->{$key} eq $arg{$key}} @sub_choice; }}
		for my $key (keys %arg) {
			if ($key eq 'sort') {
				@sub_choice = my_sort(\@sub_choice, $arg{$key}); last; }}
		for my $key (keys %arg) {
			if ($key !~ m/columns?|$str_filt|sort/) {
				@sub_choice = grep {$_->{$key} == $arg{$key}} @sub_choice; }}
		for my $key (keys %arg) {
			if ($key =~ m/columns?/) {
				if ( $arg{$key} eq '' ) { return; }
				push @print_ar, \@sub_choice, $arg{$key};
				return \@print_ar;
				}}		
	if (!@sub_choice) { return; }
	push @print_ar, \@sub_choice; 
	return \@print_ar;
}

sub my_sort{
	my @ar_sort = @{$_[0]};
	my $param = $_[1];
	if ($param =~ m/$str_filt/) { 
		@out_ar = sort { $a -> {$param} cmp $b -> {$param}} @ar_sort 
		} else { 
		@out_ar = sort { $a -> {$param} <=> $b -> {$param}} @ar_sort 
		}
	return @out_ar;}
	
1;
