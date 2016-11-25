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
my $str;

sub reduce_all {
	my $self = shift;
	while(defined(my $value = $self -> return_value)) {
		$sum += $value;
		$self -> {value} = $sum;} 
	return $sum; 
}

sub reduce_n {
	my $self = shift;
	my $n = shift;
	for (1..$n) { 
		if (defined(my $value = $self -> return_value)) {
			$sum += $value;
		} else { $self -> {value} = $sum; return $sum; }
	}
	$self -> {value} = $sum;
	return $sum;
}

1;