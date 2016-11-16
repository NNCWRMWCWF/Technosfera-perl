package Local::Reducer::Sum;
use base qw(Local::Reducer);
use strict;
use warnings;
use DDP;

=encoding utf8

=head1 NAME

Local::Reducer - base abstract reducer

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

my $sum = 0;

sub reduce_all {
	my $self = shift;
	while(1) { 
		my $str = $self -> {source} -> next;
		if (!defined $str) { print "$sum\n"; $self -> {sum} = $sum; return $sum; }
		$sum += $self -> {row_class} -> new(str => $str) -> get($self -> {field}, 0);
	}
}
sub reduce_n {
	my $self = shift;
	my $n = shift;
	for (1..$n) { 
		my $str = $self -> {source} -> next;
		if (!defined $str) { print "$sum\n"; $self -> {sum} = $sum; return $sum; }
		$sum += $self -> {row_class} -> new(str => $str) -> get($self -> {field}, 0);
	}
	$self -> {sum} = $sum;
	return $sum;
}

sub reduced { my $self = shift; $self -> {sum}; }

1;