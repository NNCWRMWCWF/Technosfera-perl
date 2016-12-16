package Local::TCP::Calc::Server;

use strict;
use warnings;
use POSIX qw( WNOHANG WIFEXITED );
use IO::Socket;
use FileHandle;
use Local::TCP::Calc;
use Local::TCP::Calc::Server::Queue;
use Local::TCP::Calc::Server::Worker;
use Local::TCP::Calc::Calculator;
use DDP;

my $max_worker;
my $in_process = 0;

my %pids_master = ();
my $receiver_count = 0;
my $max_forks_per_task = 0;

sub REAPER {
	# Функция для обработки сигнала CHLD
	while( my $pid = waitpid(-1, WNOHANG)){
		last if $pid == -1;
		if ( WIFEXITED($?) ){
			my $status = $? >> 8;
			print "$pid exit with status $status $/";
		} else {
			print "Process $pid sleep $/" ;
		}
	}
};
$SIG{CHLD} = \&REAPER;

sub start_server {
	$| = 1;
	my ($pkg, $port, %opts) = @_;
	my $max_queue_task  = $opts{max_queue_task}// die "max_queue_task required";
	$max_worker         = $opts{max_worker} // die "max_worker required"; 
	$max_forks_per_task = $opts{max_forks_per_task} // die "max_forks_per_task required";
	my $max_receiver    = $opts{max_receiver} // die "max_receiver required"; 
	#...
	# Инициализируем сервер my $server = IO::Socket::INET->new(...);
	my $server = IO::Socket::INET->new(LocalPort => $port, Type => SOCK_STREAM, ReuseAddr => 1, Listen => 10) or die "Can't create server on port $port : $@ $/";
	# Инициализируем очередь my $q = Local::TCP::Calc::Server::Queue->new(...);
	my $fh = new FileHandle;
	my $q = Local::TCP::Calc::Server::Queue->new(f_handle => $fh, max_task => $max_worker);
  	#...
	$q->init();
	#...
	while(my $client = $server->accept()){
		if ($in_process == $max_worker) { 
			p $in_process;
			print $client Local::TCP::Calc -> pack_header(Local::TCP::Calc::TYPE_CONN_ERR(), 0)."\n";
			close $client;
		} elsif ($in_process < $max_receiver) {
			$in_process++;
			print $client Local::TCP::Calc -> pack_header(Local::TCP::Calc::TYPE_CONN_OK(), 0)."\n";
			my $child = fork();
			$receiver_count++;
			if($child){ close ($client); $pids_master{$child} = $in_process++; next;}
			if(defined $child){
				chomp(my $message = <$client>);
				my $header = Local::TCP::Calc -> unpack_header($message);
				chomp(my $msg = <$client>);
				p $msg;
				$msg = Local::TCP::Calc -> unpack_message($msg);
				p $msg;
				if (${$header}[0] == Local::TCP::Calc::TYPE_START_WORK()) { 
					push my @new_work, $in_process, Local::TCP::Calc -> STATUS_NEW(), $msg;
					p  @new_work;
					$q ->  add(\@new_work) or die "Can't add task to queue: $!";
					print $client "[".$in_process."]\n";
					#Local::TCP::Calc::Server::new -> 
					check_queue_workers($q);
				} else {
					my $msg =~ m/\[(\d+)\]/;
					my $str = $q ->  get_status($1);
					if ($str =~ m/(done|error)(.+)/) {
						syswrite $client, $1 == length $1 or die "can't write to $client : $!";
					    open( $fh, "<:via(gzip)", $2 );
						while (<$fh>) {
							syswrite $client, $_ == length $_ or die "can't write to $client : $!";
                        }
						close $fh;
					unlink $2 or die "Can't delete $2: $!";
					} else {
						syswrite $client, $1 == length $1 or die "can't write to $client : $!";
					}
				}
				close( $client );
				$receiver_count--;
				exit;
			} else { die "Can't fork: $!";}
		}
	}
=head
    my $value = Local::TCP::Calc::Calculator::calculate($1);
	my $id = 1;
	$header = Local::TCP::Calc -> pack_header(Local::TCP::Calc::STATUS_DONE(), length '['.$value.']');
	print $client $header."\n";
	$msg = Local::TCP::Calc -> pack_message('['.$value.']');
	print $client $msg."\n";
    close( $client );}
=cut	
	# Начинаем accept-тить подключения
	# Проверяем, что количество принимающих форков не вышло за пределы допустимого ($max_receiver)
	# Если все нормально отвечаем клиенту TYPE_CONN_OK() в противном случае TYPE_CONN_ERR()
	# В каждом форке читаем сообщение от клиента, анализируем его тип (TYPE_START_WORK(), TYPE_CHECK_WORK()) 
	# Не забываем проверять количество прочитанных/записанных байт из/в сеть
	# Если необходимо добавляем задание в очередь (проверяем получилось или нет) 
	# Если пришли с проверкой статуса, получаем статус из очереди и отдаём клиенту
	# В случае если статус DONE или ERROR возвращаем на клиент содержимое файла с результатом выполнения
	# После того, как результат передан на клиент зачищаем файл с результатом
}

sub check_queue_workers {
	#my $self = shift;
	#p $self;
	my $q = shift;
	my $ref = $q -> get;
	p $ref;
	
	# Функция в которой стартует обработчик задания
	# Должна следить за тем, что бы кол-во обработчиков не превышало мексимально разрешённого ($max_worker)
	# Но и простаивать обработчики не должны
	my $worker = Local::TCP::Calc::Server::Worker->new(cur_task_id => $ref -> [0], calc_ref => Local::TCP::Calc::Calculator::calculate, max_forks => $max_forks_per_task);
	my ($id, $task) = $worker -> start($ref -> [1]);
	$q->to_done($id, $task);
}

1;
