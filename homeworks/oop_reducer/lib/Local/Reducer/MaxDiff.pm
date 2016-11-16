package Local::Reducer::MaxDiff;
use base qw(Local::Reducer);
use strict;
use warnings;

=encoding utf8

=head1 NAME

Local::Reducer - base abstract reducer

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut
my $diff = 0;

sub reduce_all {
	my $self = shift;
	while(1){ 
		my $str = $self -> {source} -> next;
		if (!defined $str) { print "$diff\n"; $self -> {diff} = $diff; return $diff; }
		my $top_value = $self -> {row_class} -> new(str => $str) -> get($self -> {top}, 0);
		my $bottom_value = $self -> {row_class} -> new(str => $str) -> get($self -> {bottom}, 0);
		$diff = $top_value - $bottom_value > $diff ? $top_value - $bottom_value : $diff;
	}
}

sub reduce_n {
	my $self = shift;
	my $n = shift;
		for (1..$n) {
			my $str = $self -> {source} -> next;
			if (!defined $str) { print "$diff\n"; return $diff; }
			my $top_value = $self -> {row_class} -> new(str => $str) -> get($self -> {top}, 0);
			my $bottom_value = $self -> {row_class} -> new(str => $str) -> get($self -> {bottom}, 0);
			$diff = $top_value - $bottom_value > $diff ? $top_value - $bottom_value : $diff;
			$self -> {diff} = $diff;
			}
	return $diff;
}

sub reduced {my $self = shift; $self -> {diff}; }
1;