library(data.table)
library(magrittr)
library(dplyr)
library(devtools)
library(R.utils)
library(CARMA)

root<-"/well/PROCARDIS/cgrace/CARMA/GCTA++/"

args = commandArgs(trailingOnly=TRUE)
loci<-args[1]

sumstat<- fread(file = paste0(root,"files_wannot/loci_",loci,".summstat-aligned.txt"),
                sep = "\t", header = T, check.names = F, 
                data.table = F,stringsAsFactors = F)

#head(sumstat)

## loci_1_ld_ld.ld.gz
ld = fread(file = paste0(root,"files_wannot/loci_",loci,"_ld_ld.ld.gz"),
           sep = " ", header = F, check.names = F, 
           data.table = F,stringsAsFactors = F)

#head(ld)

z.list<-list()
ld.list<-list()
lambda.list<-list()

z.list[[1]]<-sumstat$Z
ld.list[[1]]<-as.matrix(ld)
lambda.list[[1]]<-1

# typeof(sumstat$Z)
# message(ld[1,1])
# typeof(ld[1,1])
# typeof(lambda.list)

annot=fread(file = paste0(root,"files_wannot/loci_",loci,".Aorta-aligned.txt"),
            sep="\t", header = T, check.names = F, data.table = F,
            stringsAsFactors = F)

#head(annot)

# ###### z.list and ld.list stay the same with the previous setting,
# ###### and we add annotations this time.
annot.list<-list()
annot.list[[1]]<-annot

# CARMA.results<-CARMA(z.list,
# 	ld.list,
# 	lambda.list=lambda.list,
# 	outlier.switch=T,
# 	printing.log=T)

CARMA.results<-CARMA(z.list,
                     ld.list,
                     lambda.list=lambda.list,
                     w.list=annot.list,
                     outlier.switch=T,
                     printing.log=T)

# #print(CARMA.results)

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
       file = paste0(root,"files_wannot/loci_",loci,"_sumstats__carma_ndir_annot.txt.gz"),
       sep = "\t", quote = F, na = "NA", row.names = F, col.names = T,
       compress = "gzip")
