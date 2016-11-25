package Local::Row::JSON;

use strict;
use warnings;
use DDP;
use JSON::XS;
use base qw(Local::Row::Simple);
no warnings 'experimental';

sub get {
	my ($self, $name, $default) = @_;
	my $st = $self -> {str};
	my $out = JSON::XS -> new -> utf8 -> decode($st) -> {$name};
	return $out ? $out : $default;
}

1;