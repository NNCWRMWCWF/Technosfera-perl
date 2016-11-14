package Local::JSONParser;

use 5.010;
use utf8;

use open qw(:std :utf8);
use strict;
use warnings;
no warnings 'experimental';
use base qw(Exporter);
use DDP;
use feature 'switch';
our @EXPORT_OK = qw( parse_json );
our @EXPORT = qw( parse_json );

sub parse_json {
	my ($key, $val, $line, %hash, @ar);
	my $source = shift;
	if ($source =~ /^\[\s*(.*?)\s*\]\s*$/s) {
		@ar = split /(?<!\\"),\s*(?!.+}|.+])/, $1;
		for my $i (0..$#ar) {
			given($ar[$i]) {	
				when(/^\[\s*.+\s*\]/) { 
				$ar[$i] = parse_json($ar[$i]);
				}
				when(/^{.*?}$/){ 
				$ar[$i] = parse_json($ar[$i]);  
				}
				when(/".+"/) { 
					$ar[$i] =~ /"(.+)"/;
					$ar[$i] = $1; 
					$ar[$i] =~ s/\\"/"/;
					$ar[$i] =~ s/\\t/	/;
					$ar[$i] =~ s/\\u([0-9a-fA-F]{4})/chr(hex$1)/ge;
					#$ar[$i] =~ s/\\x{([0-9a-fA-F]{3})}/chr(hex$1)/ge;
					#$ar[$i] = decode("utf-8", $ar[$i]);
					}
				when(/[\d\.\-]+/) {}
				default { die "Bad command to operate to"; }}}
		return \@ar;
		} elsif ($source=~/\s*{\s*(.*)\s*}\s*/s) {
	         $_ = $1;
			 if (/\s*\n*"(?:[\w ]+?)"\s*:\s*(?:".+"|[\d\.\-]+|\[.+\]|{.+?})(?:,|$|\s)/){print "Yes\n";
	while (/\s*\n*"([\w\\ "]+?)"\s*:\s*(".+?"|[\d\.\-]+|\[.+\]|{.+?})(?:,|$|\s)/gs){
		$key = $1;
		$val = $2;
		$key =~ s/\\"/"/;
		given($val) {
			when(/\[\s*.+\s*\]/s) {
				$hash{$key} = parse_json($val);}
			when(/\{\s*.*\s*\}/){ 
				$hash{$key} = parse_json($val);}
			when(/".+"/) {
			$val =~ s/\\"/"/;
			$val =~ /"(.+)"/; 
			$val = $1;
			$val =~ s/\\u([0-9a-fA-F]{4})/chr(hex$1)/ge;
			$hash{$key} = $val; }
			when(/[\d\.\-]+/) {$hash{$key} = $val; }
			default { die "Bad command to operate to"; }
		}
		}} elsif (!$_|/\\n/) { return  \%hash; } else { die "Bad command to operate to"; }
	return \%hash;
} else { die "Bad command to operate to"; }}

1;
