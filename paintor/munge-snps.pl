#!/usr/bin/perl

use strict;
use warnings;

my $loci = $ARGV[0];
my $iter = $ARGV[1];

## chr pos rsid a1 a2 Zscore
open(my $f, "$loci.maf005.iter".$iter.".processed");
open(my $o, "> $loci\_in.bed");

my $h = <$f>; ## no header

while(my $line = <$f>){
    chomp $line;
    my ($chr,$pos,$rsid,@rest) = split " ", $line;
    my $pos0 = $pos - 1;

    print $o "chr$chr\t$pos0\t$pos\t$rsid\n";
}

close($f);
