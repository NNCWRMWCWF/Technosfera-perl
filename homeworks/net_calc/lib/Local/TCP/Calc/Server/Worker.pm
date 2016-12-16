package Local::TCP::Calc::Server::Worker;

use strict;
use warnings;
use Mouse;
use Storable;

has cur_task_id => (is => 'ro', isa => 'Int', required => 1);
has forks       => (is => 'rw', isa => 'HashRef', default => sub {return {}});
has calc_ref    => (is => 'ro', isa => 'CodeRef', required => 1);
has max_forks   => (is => 'ro', isa => 'Int', required => 1);

sub write_err {
	my $self = shift;
	my $error = shift;
	...
	# Записываем ошибку возникшую при выполнении задания
}

sub write_res {
	my $self = shift;
	my $res = shift;
	...
	# Записываем результат выполнения задания
}

sub child_fork {
	my $self = shift;
	...
	# Обработка сигнала CHLD, не забываем проверить статус завершения процесса и при надобности убить оставшихся
}

sub start {
	my $self = shift;
	my $task = shift;
	my @result_task = qw();
	my $file = "/tmp/$self -> {cur_task_id}.txt";
	store \@result_task, $file;
	my $count = 0;
	my $forks = 0;
	for my $i (@{$task}) {
		my $pid = fork();
		if (not defined $pid) { warn "Could not fork"; next; }
		if ($pid) { 
			$forks++;
		} else {
		$count++; 
		my $res = self->calc_ref($i);
		open( my $fh, '+<', $file );
		flock ($fh, 2);
		my $arref = retrieve_fd($fh);
		${$arref}[$count] = $res;
		truncate($fh, 0);
		store_fd($arref, $fh);
		close $fh;
		exit;
=head
		if ($res =~ m/Error/) { 
			$self -> write_err($res); 
		} else { $self -> write_res($res); }
		exit;
=cut
        }
		for (1..$forks) { my $pid = wait(); }
	}
	open (my $fh1, '<', $file);
	open (my $fh2, ':>(gzip)', "/tmp/$self -> {cur_task_id}.gz");
	while (<$fh1>){
		print $fh2 $_;}
	close $fh1;
	close $fh2;
	return ($self -> cur_task_id, "/tmp/$self -> {cur_task_id}.gz");
	# Начинаем выполнение задания. Форкаемся на нужное кол-во форков для обработки массива примеров
	# Вызов блокирующий, ждём  пока не завершатся все форки
	# В форках записываем результат в файл, не забываем про локи, чтобы форки друг другу не портили результат
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1;
