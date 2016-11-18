use strict;
use warnings;
use DDP;

my %has;
my @ar;
my @ar1;
my $e=0;
while(my $line = <STDIN>) {
  chomp($line);
  @ar = split/\s+/,$line; 
  last if ($line eq "exit");
  for my $w (@ar){
    @{$has{$w}} = @ar;}
}
p %has;

for my $key (keys %has){
#print "key $key\n";
	for my $k (keys %has){
	#print "k $k\n";
		my $bol = 1;
		for my $i (@{$has{$key}}) {
			#print "i $i\n";
			if ($k eq $i) { $bol = 0; }}
			if ($bol) {
			print "$key -> $k\n"; 
			push $has{$k}, $key; 
			for my $key1 (keys %has) {
			push $has{$key1}, $k;}
			last;
			}
}}

