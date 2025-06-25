#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

## plink_ukbb/snptestid/ukb_v3_maf_imp_1_eur.bim

my %HASH = ();

my $chr = $ARGV[1];

open(my $F, $ARGV[0]);

while(my $id = <$F>){
    chomp $id;
    $id=~s/chr//g;
    $id=~/(.*)\:(.*)\_(.*)\_(.*)/;

    $HASH{$1}{$2}{"$3_$4"}++;
    $HASH{$1}{$2}{"$4_$3"}++;
}

close($F);

#print Dumper(%HASH);

open(my $BIM, "plink_ukbb/snptestid/ukb_v3_maf_imp_${chr}_eur.bim");

my $prefix=$ARGV[2];
open(my $O1,  ">${prefix}_ids.txt");
open(my $O2,  ">${prefix}_in.bim");

while(my $l = <$BIM>){
    chomp $l;
    my ($chr, $id, $dum, $bp, $ref, $alt) = split "\t", $l;

    if(exists($HASH{$chr}{$bp}{$ref."_".$alt}) || exists($HASH{$chr}{$bp}{$alt."_".$ref})){
	print $O1 "$id\n";
	print $O2 "$l\n";
    }
}

close($O1);
close($O2);
close($BIM);

