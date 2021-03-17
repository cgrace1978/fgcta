#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "dcdflib.h"
//#include <gsl/gsl_cdf.h>

double chiprob_p(double xx, double df) {
  int st = 0;
  int ww = 1;
  double bnd = 1;
  double pp;
  double qq;
  cdfchi(&ww, &pp, &qq, &xx, &df, &st, &bnd);
  if (st) {
    return -9;
  }
  return qq;
}

double inverse_chiprob(double qq, double df) {
  double pp = 1 - qq;
  int32_t st = 0;
  int32_t ww = 2;
  double bnd = 1;
  double xx;

  if (qq >= 1.0) {
    return 0;
  }
  cdfchi(&ww, &pp, &qq, &xx, &df, &st, &bnd);
  if (st != 0) {
    return -9;
  }
  return xx;
}

double calcBayesianScaling(double beta, double se, double fold, int enrich,
			   double *adjse, double *adjp){
  // calculate the chisq and corresponding p-value.
  double chisq = pow(beta,2) / pow(se,2);
  double chisq_p = chiprob_p(chisq,1);
  double chisq_p_2 = 1 - chisq_p;

  // convert the enrichment scaling into prior probability.
  double enrich_or = fold;
  if(enrich == 0){
    enrich_or = 1 / enrich_or;
  }

  double prior_t = enrich_or / (enrich_or + 1);
  double prior_f = 1 - prior_t;

  // calculate the posterior probability from prior and baseline p-value
  double joint_rej = chisq_p*prior_f;
  double joint_acc = chisq_p_2*prior_t;

  double post = joint_rej / (joint_acc + joint_rej);

  // convert the posterior probability into chisq and scale the se as apropriate
  double chisq_post = inverse_chiprob(post, 1);

  double adjse1=sqrt((pow(beta,2)/chisq_post));
  double varmulti=pow(adjse1,2)/pow(se,2);

  *adjse = adjse1;
  *adjp = post;
  
  return(varmulti);
}

int main(int argc, char **argv){
  fprintf(stderr,"### Bayesian Scaling\n");
  fprintf(stderr, "### arg1: input *.ma file\n");
  fprintf(stderr, "### arg2: output *.ma file\n");
  fprintf(stderr, "### arg3: scaling factor\n");

  FILE *fp;
  FILE *wfp;
  char * line  = NULL;
  size_t len = 0;
  ssize_t read;
  
  if(argc == 1){
    fprintf(stderr, "Error: please provide a filename...\n");
    exit(EXIT_FAILURE);
  }
  
  fp = fopen(argv[1], "r");
  wfp = fopen(argv[2],"w");
  double fold = atof(argv[3]);

  fprintf(wfp,"snp a1 a2 freq beta se p n chr bp annot\n");

  
  if(fp == NULL){
    fprintf(stderr, "Error: Could not open file: %s...\n", argv[1]);
    exit(EXIT_FAILURE);
  }

  // read the header
  read = getline(&line, &len,fp);

  while((read = getline(&line, &len,fp )) != -1){

    line[strcspn(line, "\n")] = 0;
    
    char* snp;
    snp = strtok(line, " ");
    
    char* a1;
    a1 = strtok(NULL, " ");

    char* a2;
    a2 = strtok(NULL, " ");
    
    char* pch;

    pch = strtok(NULL ," ");
    float freq = atof(pch);

    pch = strtok(NULL, " ");
    float beta = atof(pch);

    pch = strtok(NULL, " ");
    float se = atof(pch);

    pch = strtok(NULL, " ");
    float p = atof(pch);
    
    pch = strtok(NULL, " ");
    int n = atoi(pch);

    pch = strtok(NULL, " ");
    int chr = atoi(pch);

    pch = strtok(NULL, " ");
    int bp = atoi(pch);

    pch = strtok(NULL, " ");
    int annot = atoi(pch);
        
    double adjse = 0;
    double adjpval = 0;
    
    double scaling = calcBayesianScaling(beta,se,fold,annot, &adjse, &adjpval);

    fprintf(wfp,"%s %s %s %.7f %.7f %.7f %.7f %i %i %i %i\n",
    	   snp, a1,a2, freq, beta, adjse, adjpval, n, chr, bp, annot);
  }
  
  fclose(fp);
  fclose(wfp);
  
  return 1;
}
