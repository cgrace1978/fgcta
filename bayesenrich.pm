#!/usr/bin/perl

package bayesenrich;
use strict;
use warnings;
#use lib("/home/cgrace/perl.pm/");
use Statistics::Distributions;

## Calculate the Bayesian scaling factor
## beta - effect size of the variant
## se - the standard error of the variant
## fold - enrichment of the annotation
## enriched - does the variant overlap with the annotation.
sub calcBayesianScaling{
    my ($beta, $se, $fold, $enriched) = @_;

    print STDERR "Calculating variance multiplier with Bayesian method...\n";
    print STDERR "Input: beta=$beta se=$se fold=$fold SNP enriched=$enriched\n";
    
    my $chisq = ($beta**2)/($se**2);

    print STDERR "Step 1: chisq: $chisq\n";
    
    my $chisprob=Statistics::Distributions::chisqrprob (1,$chisq);
    my $chisprob2=(1-$chisprob);

    print STDERR "Step 2: p-vals: reject null: $chisprob accept null: $chisprob2\n";
    
    my $enrichOR = $fold;

    if($enriched == 0){
	$enrichOR = (1/$fold);
    }

    print STDERR "Step 3: enrichment odds ratio: $enrichOR\n";

    my $priorT = $enrichOR/($enrichOR + 1);
    my $priorF = 1-$priorT;

    print STDERR "Step 4: Priors - FALSE: $priorF, TRUE: $priorT\n";

    my $jointReject = $chisprob*$priorF;
    my $jointAccept = $chisprob2*$priorT;

    print STDERR "Step 5: Joint - reject: $jointReject, accept: $jointAccept\n";

    my $posterior = $jointReject / ($jointReject + $jointAccept);

    print STDERR "Step 6: posterior: $posterior\n";

    my $chi2 = Statistics::Distributions::chisqrdistr(1,$posterior);

    print STDERR "Step 7: Adj ChiSq: $chi2\n";
    
    my $adjse = (($beta**2)/$chi2)**0.5;
    my $varmulti = ($adjse**2)/($se**2);

    print STDERR "Step 8: adjSE: $adjse, variance multiplier: $varmulti\n";

    return $varmulti;
}

1;
