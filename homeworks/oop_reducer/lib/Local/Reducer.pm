package Local::Reducer;

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
my $str;
my $obj;
sub new {
my $class = shift;
my %params = @_;
bless \%params, $class;
}

sub return_value {
	my $self = shift;
	if (defined ($str = $self -> {source} -> next)) {
		$obj = $self -> {row_class} -> new(str => $str);
		if ($self -> {row_class} eq "Local::Row::Simple") { 
			return $obj -> get($self -> {top}, 0) - $obj -> get($self -> {bottom}, 0);
		} else { return $obj -> get($self -> {field}, 0);}
	} else {return undef;}
}

sub reduced { my $self = shift; $self -> {value} }

1;
