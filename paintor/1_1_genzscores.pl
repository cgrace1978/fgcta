#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my %hash = ();

my $gene=$ARGV[0]; 
my $inchr=$ARGV[1];my $st=$ARGV[2];my $en=$ARGV[3];
my $iter=$ARGV[4];

## Markername      chr     bp      a1      a2      eaf     FreqSE  MinFreq MaxFreq beta    se      pval    Direction       HetISq  HetChiSq   HetDf   HetPVal Cases   Effective_Cases n       Meta_analysis   snp
open(my $f, "zcat ../cad/CHD_meta_SAIGE_complete_filtered_30.1.19_formatted.out.gz |");

my $h=<$f>;

while(my $line = <$f>){
    chomp $line;
    my @data = split "\t", $line;
    my $chr = $data[1]; my $bp = $data[2];

    if($chr == $inchr){
	if($bp >= $st && $bp <= $en){
	    my $snp = $data[21]; my $a1 = $data[3]; my $a2 = $data[4];
	    my $b = $data[9]; my $se = $data[10];
	    
	    my $eaf = $data[5];

	    if($eaf >= 0.005 && $eaf <= 0.995){
		my %tmphash = ();
		$tmphash{"snp"} = $snp;
		$tmphash{"a1"} = $a1;
		$tmphash{"a2"} = $a2;
		$tmphash{"b"} = $b;
		$tmphash{"se"} = $se;

		push @{$hash{$chr}{$bp}}, \%tmphash;
	    }
	}
    }
}

close($f);

open(my $o, "> $gene.maf005.iter" . $iter);
print $o "chr\tpos\trsid\ta1\ta2\tZscore\n";
foreach my $chr (sort{$a<=>$b}(keys(%hash))){
    foreach my $bp (sort{$a<=>$b}(keys(%{$hash{$chr}}))){
	foreach my $tmp (@{$hash{$chr}{$bp}}){	
	    my %tmphash = %{$tmp};
	    my $snp = $tmphash{"snp"};
	    my $a1 = $tmphash{"a1"};
	    my $a2 = $tmphash{"a2"};
	    my $b = $tmphash{"b"};
	    my $se = $tmphash{"se"};
	    
	    my $z = $b / $se;

	    print $o "$chr\t$bp\t$snp\t$a1\t$a2\t$z\n";
	}
    }
}

close($o);
##print Dumper(%hash);
