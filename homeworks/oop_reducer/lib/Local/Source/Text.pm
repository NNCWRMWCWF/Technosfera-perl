package Local::Source::Text;

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
	my @text_ar = split $self -> {delimeter} ? $self -> {delimeter} :'\n', $self -> {text};
	return $i <= $#text_ar ? $text_ar[$i++] : undef;
} 

1;