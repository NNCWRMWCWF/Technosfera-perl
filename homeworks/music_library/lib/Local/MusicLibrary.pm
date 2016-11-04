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

my (@sub_choice, @ar, @out_ar, @arg, $j, %arg);

sub choice {
	$j = 0;
	@sub_choice = @{$_[0]};
	if ( @sub_choice == 0 ) { return; }
	%arg = %{$_[1]};
	$_ = $_[1];
    	for my $key (keys %arg) {
			if ($key eq 'year') {
				@sub_choice = grep {$_->{year} == $arg{$key}} @sub_choice; last; }}
		for my $key (keys %arg) {
			if ($key =~ m/band|track|format|album/) {
				@sub_choice = grep {$_->{$key} eq $arg{$key}} @sub_choice; last; }}
		for my $key (keys %arg) {
			if ($key eq 'sort') {
				@sub_choice = my_sort(\@sub_choice, $arg{$key}); last; }}
		for my $key (keys %arg) {
			if ($key =~ m/columns?/) {
				if ( $arg{$key} eq '' ) { return; }
				Local::Print::my_print(\@sub_choice, $arg{$key});return;}
				}
	if (!@sub_choice) { return; }
	Local::Print::my_print(\@sub_choice);
}

sub my_sort{
	my @ar_sort = @{$_[0]};
	my $param = $_[1];
	if ($param eq "year") { 
		@out_ar = sort { $a -> {year} <=> $b -> {year}} @ar_sort 
		} else { 
		@out_ar = sort { $a -> {$param} cmp $b -> {$param}} @ar_sort 
		}
	return @out_ar;}
	
1;
