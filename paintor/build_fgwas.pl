#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $loci = $ARGV[0];
my $chr = $ARGV[1];

my $header = "CHR\tPOS0\tPOS\tSNPID";

my $bedtoolscmd = "/apps/well/bedtools/2.24.0/bedtools";
my $directory = "./"; ##"/well/PROCARDIS/cgrace/GCTA-COJO/FN1_NULL_4.16E-5_N1000/annot/"; 
my $annotbed = "extendedmodel_150219.chr$chr.bed"; 
my $gwasbed = "$loci\_in.bed"; 
my $outputfile = "$loci\_annot.txt"; 

print STDERR "Munging FGWAS input: $annotbed, $gwasbed, $outputfile...\n";

print STDERR "Running bedtools intersect...\n";

my $catcmd = "cat ".$directory.$gwasbed." | cut -f 1,2,3,4 > ".$directory."temp1.bed";
#print "$catcmd\n";
`$catcmd`;

my $btcmd =  "$bedtoolscmd intersect -a ".$directory."temp1.bed -b ".$directory.$annotbed. " -wb > ". $directory."intersect1.temp";
#print "$btcmd\n";
`$btcmd`;


print STDERR "Building the dictionary...\n";
my %dictionary = ();
my %annotlist = ();

## chr19   91105   91106   rs2531248       chr19   90800   91200   E066
open(my $isf, $directory."intersect1.temp");

while(my $line = <$isf>){
    chomp $line;
    my @data = split "\t", $line;
    my $chr = $data[0]; my $pos = $data[2]; my $annot = $data[7];

    my $snp = "$chr:$pos";

    $dictionary{$annot}{$snp} = $snp;
    $annotlist{$annot}++;
}

close($isf);

#print Dumper(%dictionary);

print STDERR "Building the matrix...\n";

## chr1    109600119       109600120       rs13303339
open(my $gwasf, $directory.$gwasbed);

open(my $o, ">".$directory.$outputfile);

print $o "$header";
foreach my $annot (sort(keys(%annotlist))){
     print $o "\t$annot";
}

print $o "\n";

# my %duplicates = ();

while(my $line = <$gwasf>){
    chomp $line;
    my @data = split "\t", $line;
    my $chr = $data[0]; my $pos = $data[2]; my $snpid = $data[3];
    my $snp = "$chr:$pos";
    
    my $outline =  "$line";

    ## ensure no duplicate SNPs (by name)
#    if(exists($duplicates{$snpid})){next;}
#    $duplicates{$snpid}++;

    foreach my $annot (sort(keys(%annotlist))){
	if(exists($dictionary{$annot}{$snp})){
	    $outline="$outline\t1";
	}
	else{
	    $outline="$outline\t0";
	}
    }

    print $o "$outline\n";
}

close($gwasf);
close($o);
