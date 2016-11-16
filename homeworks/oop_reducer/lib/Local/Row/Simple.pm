package Local::Row::Simple;

use strict;
use warnings;
no warnings 'experimental';

sub new {
	my $class = shift;
	my %params = @_;
	bless \%params, $class;
}

sub get {
	my $self = shift;
	my $name = shift;
	my $default = shift;
	$self -> {str} =~ m/$name:\s*(\d+)/;
	return $1 ? $1 : $default;
}

1;