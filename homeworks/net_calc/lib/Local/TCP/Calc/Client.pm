package Local::TCP::Calc::Client;

use strict;
use warnings;
use IO::Socket;
use Local::TCP::Calc;
use DDP;
use JSON::XS;
use 5.010;

$| = 1;

sub set_connect {
	my $pkg = shift;
	my $ip = shift;
	my $port = shift;
	my $server = IO::Socket::INET->new(
    	PeerAddr => $ip,
    	PeerPort => $port,
    	Proto => "tcp",
    	Type => SOCK_STREAM)
	or die "Can't connect to remote server $/";
	chomp(my $msg = <$server>);
	my $header = Local::TCP::Calc -> unpack_header($msg);
	if (${$header}[0] == Local::TCP::Calc::TYPE_CONN_ERR()) {
		die "host is busy";
	} else {return $server;}
	#...
	# read header before read message
	# check on Local::TCP::Calc::TYPE_CONN_ERR();
	#...
}

sub do_request {
	my $pkg = shift;
	my $server = shift;
	my $type = shift;
	my $message = shift;
	p $message;
	my $msg = Local::TCP::Calc -> pack_message($message);
	p $msg;
	my $header = Local::TCP::Calc -> pack_header($type, length $msg);
	#$server -> autoflush(1);
	print $server $header."\n";
	print $server $msg."\n";
	if ($type == Local::TCP::Calc -> TYPE_START_WORK()) {
		chomp(my $line = <$server>);
		return $line;
	} else { 
		$message =~ m/\[(\d+)\]/;
		chomp(my $line = <$server>);
		my $file = "$1.gz";
		open my $fh, '>:via(gzip)', $file;
		while (<$server>) {
			print $fh $_;
		}
		return $line, $file;}
	#...
	# Проверить, что записанное/прочитанное количество байт равно длинне сообщения/заголовка
	# Принимаем и возвращаем перловые структуры
	#...

	#return $struct;
}

1;

