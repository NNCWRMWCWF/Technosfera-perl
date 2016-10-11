=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, содержащий обратную польскую нотацию
Один элемент массива - это число или арифметическая операция
В случае ошибки функция должна вызывать die с сообщением об ошибке

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
use FindBin;
require "$FindBin::Bin/../lib/tokenize.pl";

sub rpn {
	my $expr = shift;
	if ($expr=~ /e{2,}|\d+\.\d+\.\d+|^\s?[-+\s]+\s?$/){
	  die "Bad: '$_'";}
	my $source = tokenize($expr);
	my @rpn;
	my @temp_stack;
	my $c1=undef;

	for my $c (@{$source}) {
	  
      next if $c =~ /^\s*$/;
      given ($c) {
        when (/^\s*$/) {}
        when (/\d/) { # элемент содержит цифру
          push (@rpn, $c);
        }
        when ([ '+','-' ]){ # элемент "+" или "-"
          if (!defined $c1 || $c1 =~ /U?[-+]|[*-+(^]/){
		    $c="U".$c;
		    push (@temp_stack, $c);}
		  else {
		    until($#temp_stack==-1 || $temp_stack[-1]=~ /[(]/){
		      push (@rpn, pop (@temp_stack));}
		    push (@temp_stack, $c);
          }
		}
		when ([ '*','/' ]){
		  until($#temp_stack==-1 || $temp_stack[-1]=~ /[+(]|^(-)/){
		    push (@rpn, pop (@temp_stack));}
		  push (@temp_stack, $c);
        }
		when ([ '^' ]){
		  #if ($temp_stack[-1]=~ /U?[+-]/){
		    #push (@rpn, pop (@temp_stack));}
		  push (@temp_stack, $c);
        }
		when ([ '(' ]){ 
          push (@temp_stack,$c);
        }
		when ([ ')' ]){
          until ($temp_stack[-1] eq "("){		
            push (@rpn, pop (@temp_stack));
          }
		  pop (@temp_stack);} 
        default {
          die "Bad: '$_'";
        }
      }
	  $c1=$c;
    }
    until($#temp_stack==-1){
	push (@rpn, pop (@temp_stack));}
	
	return \@rpn;
}

1;
