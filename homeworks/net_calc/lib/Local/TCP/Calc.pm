package Local::TCP::Calc;

use strict;

sub TYPE_START_WORK {1}
sub TYPE_CHECK_WORK {2}
sub TYPE_CONN_ERR   {3}
sub TYPE_CONN_OK    {4}

sub STATUS_NEW   {1}
sub STATUS_WORK  {2}
sub STATUS_DONE  {3}
sub STATUS_ERROR {4}

sub pack_header {
	my $pkg = shift;
	my $type = shift;
	my $size = shift; 
	my $header = pack 'C2', $type, $size;
	return $header;
}

sub unpack_header {
	my $pkg = shift;
	my $header = shift;
	(my $type, my $size) = unpack('C2', $header);
	my @ar;
	push @ar, $type, $size;
	return \@ar;
}

sub pack_message {
	my $pkg = shift;
	my $messages = shift;
    my $msg = pack 'A*', @$messages;
	return $msg;
}

sub unpack_message {
	my $pkg = shift;
	my $message = shift;
	my $msg = unpack 'A*', $message;
	return $msg;
}

1;
