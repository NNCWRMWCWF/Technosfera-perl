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
my $str;

sub reduce_all {
	my $self = shift;
	while(defined(my $value = $self -> return_value)) { 
		$diff = $value > $diff ? $value : $diff;
		$self -> {value} = $diff; }
	return $diff;
}

sub reduce_n {
	my $self = shift;
	my $n = shift;
		for (1..$n) {
			if (defined(my $value = $self -> return_value)){
			$diff = $value > $diff ? $value : $diff;
			$self -> {value} = $diff;
			} else { return $diff; }
		}
	return $diff;
}


1;