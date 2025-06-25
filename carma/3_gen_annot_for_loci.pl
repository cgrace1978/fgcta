#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $chr = $ARGV[0];
my $loci = $ARGV[1];

my %HASH1 = ();

open(my $F1, "annot/Aorta.E065.list.txt");

while(my $l = <$F1>){
    chomp $l;
    my @d = split "\t", $l;
    my $snp = $d[0]; my $E065 = $d[1];
    
    if(!($snp=~/chr$chr\:/)){next;}

    $HASH1{$snp}{"val"}=$E065;
 #   last;
}

close($F1);

#print Dumper(%HASH1);

open(my $F2, "ld_working/loci_${loci}.summstat.txt");
open(my $O1, "> files_wannot/loci_${loci}.wa.summstat.txt");
open(my $O2, "> files_wannot/loci_${loci}.Aorta.txt");

my $h = <$F2>; chomp $h;
print $O1 "$h\n";
print $O2 "Aorta\n";

while(my $l = <$F2>){
    chomp $l;
    my @d = split "\t", $l;
    my $snp1="chr".$d[1].":".$d[2]."_".$d[3]."_".$d[4];
    my $snp2="chr".$d[1].":".$d[2]."_".$d[4]."_".$d[3];
#    print "$snp1 $snp2\n";

    if(exists($HASH1{$snp1})){
	print $O1 "$l\n";
#	my $E065 = $HASH1{$snp1}{"val"};
#	print $02 $HASH1{$snp1}{"val"} . "\n";
	print $O2 $HASH1{$snp1}{"val"} . "\n";
    }
    elsif(exists($HASH1{$snp2})){
	print $O1 "$l\n";
#	my $E065 = $HASH1{$snp2}{"val"};
#	print $02 $HASH1{$snp2}{"val"} . "\n";
	print $O2 $HASH1{$snp2}{"val"} . "\n";
#	last;
    }

#    last;
}

close($F2);
close($O1);
