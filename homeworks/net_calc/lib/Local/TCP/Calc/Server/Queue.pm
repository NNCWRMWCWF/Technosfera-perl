package Local::TCP::Calc::Server::Queue;

use strict;
use warnings;
use Storable qw(store_fd store retrieve_fd retrieve);
use 5.010;
use DDP;
no if $] >= 5.018, warnings => "experimental";

use Mouse;
use Local::TCP::Calc;

has f_handle       => (is => 'rw', isa => 'FileHandle');
has queue_filename => (is => 'ro', isa => 'Str', default => 'GT.storable');
has max_task       => (is => 'rw', isa => 'Int', default => 0);

sub init {
	my $self = shift;
	my %hash_queue = ("asd" => 4);
	p $self -> {f_handle};
	open ($self -> {f_handle}, '>', $self -> {queue_filename});
	store_fd(\%hash_queue, \*$self -> {queue_filename});
	close $self -> {f_handle};
	# Подготавливаем очередь к первому использованию если это необходимо
}

sub open {
	my $hashref;
	my $self = shift;
	my $open_type = shift;
	if ($open_type == 1) { 
		open ($self -> {f_handle}, '+<', $self -> {queue_filename});
		flock($self -> {f_handle}, 2);
		$hashref = retrieve_fd($self -> {f_handle});
		truncate($self -> {f_handle}, 0);
	} else {
		open ($self -> {f_handle}, '<', $self -> {queue_filename});
		flock($self -> {f_handle}, 1);
		$hashref = retrieve_fd($self -> {f_handle});
	}
	return $hashref;
	# Открваем файл с очередью, не забываем про локи, возвращаем содержимое (перловая структура)
}

sub close {
	my $self = shift;
	my $struct = shift;
	if ($struct) { store_fd $struct, $self -> {f_handle}; }
	close $self -> {f_handle};
	# Перезаписываем файл с данными очереди (если требуется), снимаем лок, закрываем файл.
}

sub to_done {
	my $self = shift;
	my $task_id = shift;
	my $file_name = shift;
	my $structure = $self -> open(1);
	$structure -> {$task_id} -> [0] = Local::TCP::Calc -> STATUS_DONE();
	$structure -> {$task_id} -> [1] = $file_name;
	$self -> close($structure);
	# Переводим задание в статус DONE, сохраняем имя файла с резуьтатом работы
}

sub get_status {
	my $self = shift;
	my $id = shift;
	my $structure = $self -> open(2);
	my $status = $structure -> {$id} -> [0];
	given ($status) {
		when (Local::TCP::Calc -> STATUS_NEW()) { return 'new'; }
		when (Local::TCP::Calc -> STATUS_WORK()) { return 'work'; }
		when (Local::TCP::Calc -> STATUS_DONE()) { return 'done'.$structure -> {$id} -> [1];}
		when (Local::TCP::Calc -> STATUS_ERROR()) { return 'error'.$structure -> {$id} -> [1];}
		default {}
	}
	$self -> close;
	# Возвращаем статус задания по id, и в случае DONE или ERROR имя файла с результатом
}

sub delete {
	my $self = shift;
	my $id = shift;
	my $status = shift;
	my $structure = $self -> open(1);
	delete $structure -> {$id};
	$self -> close($structure);
	# Удаляем задание из очереди в соответствующем статусе
}

sub get {
	my $self = shift;
	my $structure = $self -> open(2);
	$self -> close;
	for my $i (sort keys %{$structure}) {
		if (${$structure -> {$i}}[0] == Local::TCP::Calc -> STATUS_NEW()) {
			push my @out_ar, $i, ${$structure -> {$i}}[1];
			return \@out_ar;
		}
	}
	# Возвращаем задание, которое необходимо выполнить (id, tasks)
}

sub add {
	my $self = shift;
	my $new_work = shift;
	my $structure = $self -> open(1);
	#${$new_work}[2] =~ m/\["(.+)"\]/;
	my @task = split (/,/,${$new_work}[2]);
	p @task;
	push my @full_task, ${$new_work}[1], \@task;
	$structure -> {${$new_work}[0]} = \@full_task;
	$self -> close($structure);
	# Добавляем новое задание с проверкой, что очередь не переполнилась
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1;
