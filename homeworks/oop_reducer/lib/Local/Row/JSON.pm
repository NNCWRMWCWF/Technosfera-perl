package Local::Row::JSON;

use strict;
use warnings;
use DDP;
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
	my $st = $self -> {str};
	$st =~ m/"$name":\s*(\d+)/;
	return $1 ? $1 : $default;
}

1;