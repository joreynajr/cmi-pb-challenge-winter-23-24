
library(r.jive)
library(dplyr)

setwd("C:/Users/jreyna/Documents/Projects/cmi-pb-multiomics/third_challenge")


# test data
# data(BRCA_data)
# d = Data[[1]]
# d[1:5, 1:2]
# results = jive(Data)

################################################################################
# Step 1: load the data
################################################################################
assays <- c('plasma_cytokine_concentrations', 'pbmc_cell_frequency',
            'abtiter', 'pbmc_gene_expression')

cmipb_prelim_data <- list()
cmipb_samples <- list()
for (i in seq(length(assays))){
    
    # get the current assay data
    assay <- assays[i]
    fn <- "results/main/2024.01.05/cmi_pb_datasets/computable-matrices/training_dataset/%s.training-data.tsv"
    fn <- sprintf(fn, assay)
    
    # data must be in the format rows = variables, columns = samples
    curr_data <- read.table(fn, sep='\t', na.strings = c(""), row.names = "V1")
    colnames(curr_data) <- curr_data[1,]
    curr_data <- curr_data[2:nrow(curr_data),]

    # remove incomplete columns
    curr_data <- curr_data[, complete.cases(t(curr_data))]
    
    # assign the data to cmipb_data
    cmipb_prelim_data[[i]] <- curr_data
    cmipb_samples[[i]] <- rownames(curr_data)
    
}

View(cmipb_prelim_data[[1]])

################################################################################
# Step 2: extract shared samples 
################################################################################

# find the common elements
common_samples <- Reduce(intersect, cmipb_samples)
write(common_samples,
      file = "results/main/2024.01.05/cmi_pb_datasets/computable-matrices/training_dataset/common_samples.txt",
      sep = "\n")

cmipb_data <- list()
for (i in seq(length(assays))) {

    # keep only common samples
    main_data <- cmipb_prelim_data[[i]][common_samples,]
    
    
    
    # convert all values to numeric
    curr_data <- data.frame(sapply(main_data, as.numeric))
    
    
    # reshape due to loss of dim in the previous step
    curr_data <- matrix(curr_data[,1],
                        nrow = nrow(main_data),
                        ncol = ncol(main_data),
                        byrow = TRUE)

    # convert back to dataframe and add back names
    curr_data <- as.data.frame(curr_data)
    rownames(curr_data) <- rownames(main_data)
    colnames(curr_data) <- colnames(main_data)

    # transpose for jive format
    curr_data = t(curr_data)
    cmipb_data[[i]] <- curr_data
}

################################################################################
# Step 3: run JIVE and extract components
################################################################################
# Cantini ran JIVE as such:
# https://github.com/cantinilab/momix-notebook/blob/628fcfde5e1cd3ab69d323b4be9232e480f42d31/scripts/runfactorization.R#L174C1-L175C1


# run the factorization algorithm
num.factors <- 10
factorizations_jive <- jive(cmipb_data,
                            rankJ = num.factors,
                            rankA = rep(num.factors, length(cmipb_data)),
                            method = "given",
                            conv = "default",
                            maxiter = 100,
                            showProgress=TRUE)

# extracting metagene, aka global loading values  
rankJV <- factorizations_jive$rankJ;
rankIV.v <- factorizations_jive$rankA;
J <- numeric(0)
ng <- 0
metagenes_jive <- list();
for(j in 1:length(cmipb_data)){
    J <- rbind(J,factorizations_jive$joint[[j]]);
    ng <- c(ng, dim(factorizations_jive$joint[[j]])[1])
}
svd.o <- svd(J);
jV <- svd.o$v %*% diag(svd.o$d);
for(j in 1:length(cmipb_data)){
    metagenes_jive[[j]] <- svd.o$u[(1 + sum(ng[1:j])):sum(ng[1:j+1]), 1:rankJV];
    rownames(metagenes_jive[[j]]) <- rownames(cmipb_data[[j]])
    colnames(metagenes_jive[[j]]) <- 1:num.factors
}

# extract jive factors, aka global factor scores 
factors_jive <- jV[, 1:rankJV]
rownames(factors_jive) <- colnames(cmipb_data[[1]])
colnames(factors_jive) <- 1:num.factors


final_factorizations_jive <- list(factors_jive, metagenes_jive)


################################################################################
# Step 3: save JIVE decompositions
################################################################################
    
for (i in seq(length(assays))){
    
    assay <- assays[i]
    current_loadings <- metagenes_jive[[i]]
    
    outfn <- "results/main/2024.01.05/cmi_pb_datasets/computable-matrices/training_dataset/%s.jive-loadings.tsv"
    outfn <- sprintf(outfn, assay)
    write.table(current_loadings, file=outfn, sep = '\t')
              
}


png("VarExplained.png",height=300,width=450)  
showVarExplained(factorizations_jive)  
dev.off()


png("HeatmapsBRCA.png",height=1000,width=1200)
showHeatmaps(factorizations_jive)
dev.off() 






