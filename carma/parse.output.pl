#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my %HASH = ();

sub process{
    my $file = $_[0];
    my $dir = $_[1];
    my $loci = $file;
    $loci=~s/\_sumstats\_\_carma\_ndir\.txt\.gz//g; $loci=~s/loci\_//g;
    print STDERR "processing loci $loci\n";
#    print "$loci\n";
    ## Markername      chr     bp      a1      a2      eaf     FreqSE  MinFreq MaxFreqbeta     se      pval    Direction       HetISq  HetChiSq        HetDf   HetPValCases    Effective_Cases n       Meta_analysis   snp     Z       PIP     CS
    open(my $F1, "zcat ${dir}/${file} |");

    my $h = <$F1>; chomp $h;

    while(my $l = <$F1>){
	chomp $l;
	my @d = split "\t", $l;
	my $snp = $d[0]; my $snp2 = $d[21];
	my $PIP = $d[23]; my $CS = $d[24];
	my $pval = $d[11];

    
	if($CS > 0){
	    $HASH{$loci}{$CS}{$snp}{"snp2"}=$snp2;
	    $HASH{$loci}{$CS}{$snp}{"PIP"}=$PIP;
	    $HASH{$loci}{$CS}{$snp}{"pval"}=$pval;
	}
    }

    close($F1);
}

my $dir = $ARGV[0];

opendir(my $D, $dir);

my @files = grep(/\_sumstats\_\_carma\_ndir\.txt\.gz/,readdir($D));

foreach my $file (sort(@files)){
    &process($file, $dir);
}

close($D);
#print Dumper(%HASH);

open(my $O, "> results/$dir.out");
print $O "loci\tCS\tsnptest\tsnp\tPIP\n";
foreach my $loci (sort{$a<=>$b}(keys(%HASH))){
    foreach my $CS (sort{$a<=>$b}(keys(%{$HASH{$loci}}))){
	foreach my $snp (sort(keys(%{$HASH{$loci}{$CS}}))){
	    my $snp2=$HASH{$loci}{$CS}{$snp}{"snp2"};
	    my $PIP=$HASH{$loci}{$CS}{$snp}{"PIP"};
	    my $pval=$HASH{$loci}{$CS}{$snp}{"pval"};

	    print $O "$loci\t$CS\t$snp\t$snp2\t$PIP\n";
	}
    }
}
close($O);
