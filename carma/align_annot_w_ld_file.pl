#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my @ORDERED = ();
my %HASH = ();

my $loci = $ARGV[0];

open(my $F1, "files_wannot/loci_${loci}_ld.bim");

while(my $l = <$F1>){
    chomp $l;
    my ($chr, $id, $cm, $bp, $ref, $alt) = split "\t", $l;
    $id=~s/chr//g;
    push @ORDERED, $id;
    $HASH{$id}{"ct"}++;
#    print "$l\n";
#    last;
}
    
close($F1);

open(my $F2, "files_wannot/loci_${loci}.wa.summstat.txt");
open(my $F3, "files_wannot/loci_${loci}.Aorta.txt");

my $h1 = <$F2>; chomp $h1;
my $h2 = <$F3>; chomp $h2;

while(my $l = <$F2>){
    chomp $l;
    my @d = split "\t", $l;

    my $id1=$d[1].":".$d[2]."_".$d[3]."_".$d[4];
    my $id2=$d[1].":".$d[2]."_".$d[4]."_".$d[3];

    my $l2 = <$F3>; chomp $l2;

    if(exists($HASH{$id1})){
	$HASH{$id1}{"l"}=$l;
	$HASH{$id1}{"aorta"}=$l2;
    }
    elsif(exists($HASH{$id2})){
	$HASH{$id2}{"l"}=$l;
	$HASH{$id2}{"aorta"}=$l2;
    }
}

close($F2);
close($F3);

#print Dumper(%HASH);

open(my $O1, "> files_wannot/loci_${loci}.summstat-aligned.txt");
open(my $O2, "> files_wannot/loci_${loci}.Aorta-aligned.txt");
print $O1 "$h1\n";
print $O2 "$h2\n";

foreach my $id (@ORDERED){
    if(!exists($HASH{$id}{"l"})){
	print STDERR "can't find: $id\n";
	next;
    }

    my $l = $HASH{$id}{"l"};
    print $O1 "$l\n";
    my $l2 = $HASH{$id}{"aorta"};
    print $O2 "$l2\n";
}

close($O1);
close($O2);
