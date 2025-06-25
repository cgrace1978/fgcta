library(data.table)
library(magrittr)
library(dplyr)
library(devtools)
library(R.utils)
library(CARMA)

root<-"/well/PROCARDIS/cgrace/CARMA/GCTA++/"

args = commandArgs(trailingOnly=TRUE)
loci<-args[1]

sumstat<- fread(file = paste0(root,"ld_working/loci_",loci,".summstat.txt"),
                sep = "\t", header = T, check.names = F, 
                data.table = F,stringsAsFactors = F)

#head(sumstat)

ld = fread(file = paste0(root,"ld_working/loci_",loci,"_ld.ld.gz"),
           sep = " ", header = F, check.names = F, 
           data.table = F,stringsAsFactors = F)

#head(ld)

z.list<-list()
ld.list<-list()
lambda.list<-list()

z.list[[1]]<-sumstat$Z
ld.list[[1]]<-as.matrix(ld)
lambda.list[[1]]<-1

typeof(sumstat$Z)
message(ld[1,1])
typeof(ld[1,1])
typeof(lambda.list)

CARMA.results<-CARMA(z.list,
                     ld.list,
                     lambda.list=lambda.list,
                     outlier.switch=T,
                     printing.log=T)

#print(CARMA.results)

# ###### Posterior inclusion probability (PIP) and credible set (CS)
sumstat.result = sumstat %>% mutate(PIP = CARMA.results[[1]]$PIPs, CS = 0)
if(length(CARMA.results[[1]]$`Credible set`[[2]])!=0){
    for(l in 1:length(CARMA.results[[1]]$`Credible set`[[2]])){
        sumstat.result$CS[CARMA.results[[1]]$`Credible set`[[2]][[l]]]=l
    }
}
# 
###### write the GWAS summary statistics with PIP and CS
fwrite(x = sumstat.result,
       file = paste0(root,"output_no_annot_outlier_switch/loci_",loci,"_sumstats__carma_ndir.txt.gz"),
       sep = "\t", quote = F, na = "NA", row.names = F, col.names = T,
       compress = "gzip")
