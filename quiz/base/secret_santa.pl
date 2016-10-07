use strict;
use warnings;
use Data::Dumper;

my %has;
my @ar;
my @ar1;
my $e=0;
while(my $line = <STDIN>) {
  chomp($line);
  @ar = split/\s+/,$line; 
  last if($line eq "exit");
  for my $w (@ar){
    $has{$w}=[split/\s+/,$line];}
  push(@ar1, @ar);
}
for (my $i=0; $i<$#ar1; $i++){
for (my $j=$i+1; $j<$#ar1; $j++){
$e=0; 
for my $c (@{$has{$ar1[$i]}}){
if ($ar1[$j] eq $c){$e++;}}
if ($e==0){
print "$ar1[$i]->$ar1[$j]", "\n"; shift @ar1;}
else {next;}
}}
