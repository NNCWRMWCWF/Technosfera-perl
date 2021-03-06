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
	my ($self, $name, $default) = @_;
	$self -> {str} =~ m/$name:\s*(\d+)/;
	return $1 ? $1 : $default;
}

1;