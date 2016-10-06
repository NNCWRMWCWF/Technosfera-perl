=head1 DESCRIPTION

Эта функция должна принять на вход ссылку на массив, который представляет из себя обратную польскую нотацию,
а на выходе вернуть вычисленное выражение

=cut

use 5.010;
use strict;
use warnings;
use diagnostics;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';

sub evaluate {
	my $rpn = shift;
	my @c = (@{$rpn});
	my @temp_stack;
	my $temp;
    for my $foo (@c){
	if ($foo=~ /\d/){push (@temp_stack, $foo);}
	if ($foo eq "U-"){$foo=-pop (@temp_stack); push (@temp_stack, $foo);}
	if ($foo eq "+"){push (@temp_stack,pop (@temp_stack) + pop (@temp_stack));}
	if ($foo eq "-"){push (@temp_stack,-pop (@temp_stack)+pop (@temp_stack));}
	if ($foo eq "*"){push (@temp_stack,pop (@temp_stack)*pop (@temp_stack));}
	if ($foo eq "/"){push (@temp_stack,1/pop (@temp_stack)*pop (@temp_stack));}
	if ($foo eq "^"){$temp=pop (@temp_stack); push (@temp_stack,pop (@temp_stack)**$temp);}
	}
	return $temp_stack[0];
}

1;
