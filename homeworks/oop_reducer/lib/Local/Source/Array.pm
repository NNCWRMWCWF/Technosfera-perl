package Local::Source::Array;

use strict;
use warnings;
use base "Local::Source::Text";
no warnings 'experimental';

my $i = 0;

sub new {
	my $class = shift;
	my %params = @_;
	$params{iter} = 0;
	bless \%params, $class;
}

1;