#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Math::CDF qw(:all);

## 1E-308
#my $z = qnorm($ARGV[0]);

#print "$z\n";

my @ORDERED = ();
my %HASH = ();

my $loci = $ARGV[0];

open(my $F1, "ld_working/loci_${loci}.bim");

while(my $l = <$F1>){
    chomp $l;
    my ($chr, $id, $cm, $bp, $ref, $alt) = split "\t", $l;
    $id=~s/chr//g;
    push @ORDERED, $id;
    $HASH{$id}{"ct"}++;
    #print "$l\n";
#    last;
}

close($F1);

#print Dumper(@ORDERED) . "\n\n";
#print Dumper(%HASH);

open(my $F2, "zcat CHD_meta_SAIGE_complete_filtered_30.1.19_formatted.out.gz |");

my $h = <$F2>; chomp $h;

while(my $l = <$F2>){
    chomp $l;
    my @d = split "\t", $l;
    my $p = $d[11];
    my $id1=$d[1].":".$d[2]."_".$d[3]."_".$d[4];
    my $id2=$d[1].":".$d[2]."_".$d[4]."_".$d[3];

    if(exists($HASH{$id1})){
	$HASH{$id1}{"l"}=$l;
	$HASH{$id1}{"p"}=$p;
    }
    elsif(exists($HASH{$id2})){
	$HASH{$id2}{"l"}=$l;
	$HASH{$id2}{"p"}=$p;
    }
}

close($F2);

open(my $O, "> ld_working/loci_${loci}.summstat.txt");
print $O "$h\tZ\n";

foreach my $id (@ORDERED){
    if(!exists($HASH{$id}{"l"})){
	print STDERR "can't find: $id\n";
	next;
    }

    my $l = $HASH{$id}{"l"};
    my @d = split "\t", $l;
    my $z = $d[9]/$d[10];
    print $O "$l\t$z\n";
}

close($O);

# 1       Markername
# 2       chr
# 3       bp
# 4       a1
# 5       a2
# 6       eaf
# 7       FreqSE
# 8       MinFreq
# 9       MaxFreq
# 10      beta
# 11      se
# 12      pval
# 13      Direction
# 14      HetISq
# 15      HetChiSq
# 16      HetDf
# 17      HetPVal
# 18      Cases
# 19      Effective_Cases
# 20      n
# 21      Meta_analysis
# 22      snp

