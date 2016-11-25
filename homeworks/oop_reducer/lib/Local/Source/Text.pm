package Local::Source::Text;

use strict;
use warnings;
no warnings 'experimental';
use DDP;

my $i = 0;

sub new {
	my $class = shift;
	my %params = @_;
	my @text_ar = split $params{delimeter} ? $params{delimeter} :'\n', $params{text};
	$params{array} = \@text_ar;
	$params{iter} = 0;
	bless \%params, $class;
}

sub next {
	my $self = shift;
	return $self -> {iter} <= $#{$self -> {array}} ? $self -> {array}[$self -> {iter}++] : undef;
} 

1;