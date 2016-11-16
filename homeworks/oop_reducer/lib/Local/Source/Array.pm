package Local::Source::Array;

use strict;
use warnings;
no warnings 'experimental';

my $i = 0;

sub new {
	my $class = shift;
	my %params = @_;
	bless \%params, $class;
}

sub next {
	my $self = shift;
	return $i <= $#{$self->{array}} ? $self->{array}[$i++] : undef;
}

1;