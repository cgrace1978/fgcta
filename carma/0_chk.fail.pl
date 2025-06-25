#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my %COMPLETE = ();

opendir(my $D, "output_no_annot_outlier_switch");

my @files = grep(/\.gz/,readdir($D));

foreach my $file (sort(@files)){
    my @d = split "_", $file;
    $COMPLETE{$d[1]}{"ct"}++;
}

close($D);

#print Dumper(%COMPLETE);

my %RUNNING = ();

my @jobs=`squeue -u wat910 | sed '1d'`;

foreach my $job (@jobs){
    chomp $job;
    my @job = split '\s+', $job;
    my @job2 = split "_", $job[1];
#    print "$job2[1]\n";
    $RUNNING{$job2[1]}{"ct"}++;
#    last;
}

#print Dumper(%RUNNING);

for(my $i = 1; $i <=215; $i++){
    if(!exists($COMPLETE{$i}) && !exists($RUNNING{$i}) && $i !=116){
	my $cmd="sbatch --array=$i run_carma_fgcta.sh";
	print "$cmd\n";
	if(exists($ARGV[0])&&$ARGV[0] == 1){
	    `$cmd`;
	}
    }
}
