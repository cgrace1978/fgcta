library(data.table)
library(magrittr)
library(dplyr)
library(devtools)
library(R.utils)
library(CARMA)
##### setting up the working directory or the wd where the data are stored
#setwd('CARMA')
###### load the GWAS summary statistics
sumstat<- fread(file = "Sample_data/sumstats_chr1_200937832_201937832.txt.gz",
                sep = "\t", header = T, check.names = F, data.table = F,
                stringsAsFactors = F)
###### load the pair-wise LD matrix (assuming the variants are sorted in the same order
###### as the variants in sumstat file)
ld = fread(file = "Sample_data/sumstats_chr1_200937832_201937832_ld.txt.gz",
           sep = "\t", header = F, check.names = F, data.table = F,
           stringsAsFactors = F)
##print(head(sumstat))
##print(head(ld))

z.list<-list()
ld.list<-list()
lambda.list<-list()
z.list[[1]]<-sumstat$Z
ld.list[[1]]<-as.matrix(ld)
lambda.list[[1]]<-1
# CARMA.results<-CARMA(z.list,ld.list,lambda.list=lambda.list,
# outlier.switch=F)
# ###### Posterior inclusion probability (PIP) and credible set (CS)
# sumstat.result = sumstat %>% mutate(PIP = CARMA.results[[1]]$PIPs, CS = 0)
# if(length(CARMA.results[[1]]$`Credible set`[[2]])!=0){
# for(l in 1:length(CARMA.results[[1]]$`Credible set`[[2]])){
# sumstat.result$CS[CARMA.results[[1]]$`Credible set`[[2]][[l]]]=l
# }
# }
# ###### write the GWAS summary statistics with PIP and CS
# fwrite(x = sumstat.result,
# file = "sumstats_chr1_200937832_201937832_carma.txt.gz",
# sep = "\t", quote = F, na = "NA", row.names = F, col.names = T,
# compress = "gzip")

###### load the functional annotations for the variants included in GWAS summary
###### statistics (assuming the variants are sorted in the same order as the
###### variants in sumstat file)
annot=fread(file = "Sample_data/sumstats_chr1_200937832_201937832_annotations.txt.gz",
            sep="\t", header = T, check.names = F, data.table = F,
            stringsAsFactors = F)
###### z.list and ld.list stay the same with the previous setting,
###### and we add annotations this time.
annot.list<-list()
annot.list[[1]]<-annot
CARMA.results<-CARMA(z.list,ld.list,lambda.list=lambda.list,w.list=annot.list,
                     outlier.switch=F)
###### Posterior inclusion probability (PIP) and credible set (CS)
sumstat.result = sumstat %>% mutate(PIP = CARMA.results[[1]]$PIPs, CS = 0)
if(length(CARMA.results[[1]]$`Credible set`[[2]])!=0){
    for(l in 1:length(CARMA.results[[1]]$`Credible set`[[2]])){
        sumstat.result$CS[CARMA.results[[1]]$`Credible set`[[2]][[l]]]=l
    }
}
###### write the GWAS summary statistics with PIP and CS
fwrite(x = sumstat.result,
       file = "sumstats_chr1_200937832_201937832_carma_annot.txt.gz",
       sep = "\t", quote = F, na = "NA", row.names = F, col.names = T,
       compress = "gzip")
