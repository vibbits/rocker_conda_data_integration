# Network analysis of liver expression data from female mice: finding modules related to body weight
# this is a concatinated script for WGCNA tutorial 
# taken from: https://horvath.genetics.ucla.edu/html/CoexpressionNetwork/Rpackages/WGCNA/Tutorials/
# adjusted by Oren Tzfadia 16.10.18

############################## PART 1. Data input and cleaning: ##############################

#=====================================================================================
#
#  Code chunk 1
#
#=====================================================================================


# Display the current working directory
getwd();
# If necessary, change the path below to the directory where the data files are stored. 
# "." means current directory. On Windows use a forward slash / instead of the usual \.
#workingDir = ".";
setwd("/home/rstudio/kitematic/")
#setwd("/Users/oren/VIB/DATA_INTEGRATION/D.I_Workshop/WGCNA_FemaleLiver-Data/"); 
#setwd(workingDir); 
# Load the WGCNA package
library(WGCNA);
# The following setting is important, do not omit.
options(stringsAsFactors = FALSE);
#Read in the female liver data set
femData = read.csv("LiverFemale3600.csv");
# Take a quick look at what is in the data set:
dim(femData);
names(femData);

#=====================================================================================
#
#  Code chunk 2
#
#=====================================================================================
# In addition to expression data, 
# the data files contain extra information about the surveyed probes we do not need. 
# One can inspect larger data frames such as femData by invoking R data editor via fix(femData). 
# The expression data set contains 135 samples. Note that each row corresponds to a gene and column to a sample or auxiliary information. 
# We now remove the auxiliary data and transpose the expression data for further analysis.
datExpr0 = as.data.frame(t(femData[, -c(1:8)]));
names(datExpr0) = femData$substanceBXH;
rownames(datExpr0) = names(femData)[-c(1:8)];

#=====================================================================================
#
#  Code chunk 3
#
#=====================================================================================
# We first check for genes and samples with too many missing values:
gsg = goodSamplesGenes(datExpr0, verbose = 3);
gsg$allOK

#=====================================================================================
#
#  Code chunk 4
#
#=====================================================================================
# If the last statement returns TRUE, all genes have passed the cuts. 
#If not, we remove the offending genes and samples from the data.
# printing bad samples: 
if (!gsg$allOK)
{
  # Optionally, print the gene and sample names that were removed:
  if (sum(!gsg$goodGenes)>0) 
    printFlush(paste("Removing genes:", paste(names(datExpr0)[!gsg$goodGenes], collapse = ", ")));
  if (sum(!gsg$goodSamples)>0) 
    printFlush(paste("Removing samples:", paste(rownames(datExpr0)[!gsg$goodSamples], collapse = ", ")));
  # Remove the offending genes and samples from the data:
  datExpr0 = datExpr0[gsg$goodSamples, gsg$goodGenes]
}


#=====================================================================================
#
#  Code chunk 5
#
#=====================================================================================

# Next we cluster the samples (in contrast to clustering genes that will come later) to see if there are any obvious
sampleTree = hclust(dist(datExpr0), method = "average");
# BEFORE plotting -> first mkdir Plots FOLDER 
# Plot the sample tree: Open a graphic output window of size 12 by 9 inches
# The user should change the dimensions if the window is too large or too small.
sizeGrWindow(12,9)
#pdf(file = "Plots/sampleClustering.pdf", width = 12, height = 9);
par(cex = 0.6);
par(mar = c(0,4,2,0))
plot(sampleTree, main = "Sample clustering to detect outliers", sub="", xlab="", cex.lab = 1.5, 
     cex.axis = 1.5, cex.main = 2)

#dev.off();

#=====================================================================================
#
#  Code chunk 6
#
#=====================================================================================

# it appers that sample F2_221 is an outlier
# Choose the "base" cut height for the female data set to trimm out outliers mice:
# Plot a line to show the cut
abline(h = 15, col = "red");
# Determine cluster under the line
clust = cutreeStatic(sampleTree, cutHeight = 15, minSize = 10)
table(clust)
# clust 1 contains the samples we want to keep.
keepSamples = (clust==1)
datExpr = datExpr0[keepSamples, ]
nGenes = ncol(datExpr)
nSamples = nrow(datExpr)

#=====================================================================================
#
#  Code chunk 7
#
#=====================================================================================

traitData = read.csv("ClinicalTraits.csv");
dim(traitData)
names(traitData)

# remove columns that hold information we do not need.
allTraits = traitData[, -c(31, 16)];
allTraits = allTraits[, c(2, 11:36) ];
dim(allTraits)
names(allTraits)

# Form a data frame analogous to expression data that will hold the clinical traits.
femaleSamples = rownames(datExpr);
traitRows = match(femaleSamples, allTraits$Mice);
datTraits = allTraits[traitRows, -1];
rownames(datTraits) = allTraits[traitRows, 1];

collectGarbage();

#=====================================================================================
#
#  Code chunk 8
#
#=====================================================================================

# Re-cluster samples
sampleTree2 = hclust(dist(datExpr), method = "average")
# Convert traits to a color representation: white means low, red means high, grey means missing entry
traitColors = numbers2colors(datTraits, signed = FALSE);
# Plot the sample dendrogram and the colors underneath.
plotDendroAndColors(sampleTree2, traitColors,
                    groupLabels = names(datTraits), 
                    main = "Sample dendrogram and trait heatmap")


#=====================================================================================
#
#  Code chunk 9
#
#=====================================================================================


save(datExpr, datTraits, file = "FemaleLiver-01-dataInput.RData")


############################## PART 2. Network construction and module detection ##############################
# Automatic, one-step network construction and module detection

#=====================================================================================
#
#  Code chunk 1  # SKIP
#
#=====================================================================================

# Display the current working directory
getwd();
# If necessary, change the path below to the directory where the data files are stored. 
# "." means current directory. On Windows use a forward slash / instead of the usual \.
workingDir = ".";
setwd(workingDir); 
# Load the WGCNA package
library(WGCNA)
# The following setting is important, do not omit.
options(stringsAsFactors = FALSE);
# Allow multi-threading within WGCNA. This helps speed up certain calculations.
# At present this call is necessary for the code to work.
# Any error here may be ignored but you may want to update WGCNA if you see one.
# Caution: skip this line if you run RStudio or other third-party R environments. 
# See note above.
#enableWGCNAThreads()
# Load the data saved in the first part
lnames = load(file = "FemaleLiver-01-dataInput.RData");
#The variable lnames contains the names of loaded variables.
lnames

#=====================================================================================
#
#  Code chunk 2
#
#=====================================================================================

# Choose a set of soft-thresholding powers
powers = c(c(1:10), seq(from = 12, to=20, by=2))
# Call the network topology analysis function
sft = pickSoftThreshold(datExpr, powerVector = powers, verbose = 5)
# Plot the results:
sizeGrWindow(9, 5)
par(mfrow = c(1,2));
cex1 = 0.9;
# Scale-free topology fit index as a function of the soft-thresholding power
plot(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
     xlab="Soft Threshold (power)",ylab="Scale Free Topology Model Fit,signed R^2",type="n",
     main = paste("Scale independence"));
text(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
     labels=powers,cex=cex1,col="red");
# this line corresponds to using an R^2 cut-off of h
abline(h=0.90,col="red")
# Mean connectivity as a function of the soft-thresholding power
plot(sft$fitIndices[,1], sft$fitIndices[,5],
     xlab="Soft Threshold (power)",ylab="Mean Connectivity", type="n",
     main = paste("Mean connectivity"))
text(sft$fitIndices[,1], sft$fitIndices[,5], labels=powers, cex=cex1,col="red")

#=====================================================================================
#
#  Code chunk 3
#
#=====================================================================================

net = blockwiseModules(datExpr, power = 6,
                       TOMType = "unsigned", minModuleSize = 30,
                       reassignThreshold = 0, mergeCutHeight = 0.25,
                       numericLabels = TRUE, pamRespectsDendro = FALSE,
                       saveTOMs = TRUE,
                       saveTOMFileBase = "femaleMouseTOM", 
                       verbose = 3)
##### ATTENTION: IF you get this error:
##### Error in (new("standardGeneric", .Data = function (x, y = NULL, use = "everything",  : 
#####  unused arguments (weights.x = NULL, weights.y = NULL, cosine = FALSE)
##### do the following: 
#in RStudio... from the "Session" pulldown, press restart R.
#library(WGCNA).
#Then run the blockwiseModules function again
#=====================================================================================
#
#  Code chunk 4
#
#=====================================================================================

# open a graphics window
sizeGrWindow(12, 9)
# Convert labels to colors for plotting
mergedColors = labels2colors(net$colors)
# Plot the dendrogram and the module colors underneath
plotDendroAndColors(net$dendrograms[[1]], mergedColors[net$blockGenes[[1]]],
                    "Module colors",
                    dendroLabels = FALSE, hang = 0.03,
                    addGuide = TRUE, guideHang = 0.05)

#=====================================================================================
#
#  Code chunk 5
#
#=====================================================================================

# assign modules to colurs 
moduleLabels = net$colors
moduleColors = labels2colors(net$colors)
MEs = net$MEs;
geneTree = net$dendrograms[[1]];
save(MEs, moduleLabels, moduleColors, geneTree, 
     file = "FemaleLiver-02-networkConstruction-auto.RData")

############################## PART 3. Relating modules to external clinical traits and identifying important genes ##############################
#In this analysis we would like to identify modules that are significantly associated with the measured clinical traits.
#Since we already have a summary profile (eigengene) for each module, we simply correlate eigengenes with external
#traits and look for the most significant associations:

#=====================================================================================
#
#  Code chunk 1
#
#=====================================================================================

# Load the expression and trait data saved in the first part
lnames = load(file = "FemaleLiver-01-dataInput.RData");
#The variable lnames contains the names of loaded variables.
lnames
# Load network data saved in the second part.
lnames = load(file = "FemaleLiver-02-networkConstruction-auto.RData");
lnames

#=====================================================================================
#
#  Code chunk 2
#
#=====================================================================================

# Define numbers of genes and samples
nGenes = ncol(datExpr);
nSamples = nrow(datExpr);
# Recalculate MEs with color labels
MEs0 = moduleEigengenes(datExpr, moduleColors)$eigengenes
MEs = orderMEs(MEs0)
moduleTraitCor = cor(MEs, datTraits, use = "p");
moduleTraitPvalue = corPvalueStudent(moduleTraitCor, nSamples);

## OPTIONAL - write correlations and p-values to tables:
# write.table(moduleTraitCor, file = "metabolites_transcriptomics_corr_matrix.txt", row.names = T, sep = "\t", quote = F)
# write.table(moduleTraitPvaluefile = "metabolites_transcriptomics_corr_matrix_pval.txt", row.names = T, sep = "\t", quote = F)
#=====================================================================================
#
#  Code chunk 3
#
#=====================================================================================

# Since we have a moderately large number of modules and traits, a suitable graphical representation will help in
# reading the table. 
sizeGrWindow(10,6)
# Will display correlations and their p-values
textMatrix =  paste(signif(moduleTraitCor, 2), "\n(",
                    signif(moduleTraitPvalue, 1), ")", sep = "");
dim(textMatrix) = dim(moduleTraitCor)
par(mar = c(6, 8.5, 3, 3));
# Display the correlation values within a heatmap plot
labeledHeatmap(Matrix = moduleTraitCor,
               xLabels = names(datTraits),
               yLabels = names(MEs),
               ySymbols = names(MEs),
               colorLabels = FALSE,
               colors = blueWhiteRed(50),
               textMatrix = textMatrix,
               setStdMargins = FALSE,
               cex.text = 0.5,
               zlim = c(-1,1),
               main = paste("Module-trait relationships"))

# greenWhiteRed: this palette is not suitable for people
# with green-red color blindness (the most common kind of color blindness).
# Consider using the function blueWhiteRed instead

#=====================================================================================
#
#  Code chunk 4  
#
#=====================================================================================

# Define variable weight containing the weight column of datTrait
# change here if you would like to correlate other trait to the modules
weight = as.data.frame(datTraits$weight_g);
names(weight) = "weight"
#### ADJUSTED ##############################################################################
# here we can add a loop for every metabolite (trait) for printinm them all later:
metabo = list()
for (i in colnames(moduleTraitPvalue)) {
  # Define variable meta containing the metabolite columns of datTrait
  meta <- data.frame(datTraits[,i]);
  meta$i <- i
  metabo[[i]] <- meta
}

metabol = do.call(cbind, metabo)
metabol <- metabol[c(T,F)]
colnames(metabol) = gsub(".datTraits...i.", "", colnames(metabol))
##################################################################################

# names (colors) of the modules
modNames = substring(names(MEs), 3)
geneModuleMembership = as.data.frame(cor(datExpr, MEs, use = "p"));
MMPvalue = as.data.frame(corPvalueStudent(as.matrix(geneModuleMembership), nSamples), append = T);

names(geneModuleMembership) = paste("MM", modNames, sep="");
names(MMPvalue) = paste("p.MM", modNames, sep="");

##################################################################################
## HERE THE CODE FORKS:
##################################################################################
## OPTION 1 JUST WEIGHT 
  geneTraitSignificance = as.data.frame(cor(datExpr, weight, use = "p"));
  GSPvalue = as.data.frame(corPvalueStudent(as.matrix(geneTraitSignificance), nSamples));

  names(geneTraitSignificance) = paste("GS.", names(weight), sep="");
  names(GSPvalue) = paste("p.GS.", names(weight), sep="");


## OPTION 2 ALL TRAITS / METABOLITES
  geneTraitSignificance = as.data.frame(cor(datExpr, metabol, use = "p"));
  GSPvalue = as.data.frame(corPvalueStudent(as.matrix(geneTraitSignificance), nSamples));

  names(geneTraitSignificance) = paste("GS.", names(metabol), sep="");
  names(GSPvalue) = paste("p.GS.", names(metabol), sep="");

#=====================================================================================
#
#  Code chunk 5   ##### ADJUSTED ##### added loop over all moudules and traits
#
#=====================================================================================

#############################   Original code:  ############################# 
module = "brown"
column = match(module, modNames);
moduleGenes = moduleColors==module;

sizeGrWindow(7, 7);
par(mfrow = c(1,1));
verboseScatterplot(abs(geneModuleMembership[moduleGenes, column]),
                   abs(geneTraitSignificance[moduleGenes, 1]),
                   xlab = paste("Module Membership in", module, "module"),
                   ylab = "Gene significance for body weight",
                   main = paste("Module membership vs. gene significance\n"),
                   cex.main = 1.2, cex.lab = 1.2, cex.axis = 1.2, col = module)

############################################################################ 
#### Adjusted code (here we are adding automatic loop to plot module memberships for ALL traits)
### IMPORTANT!!! mkdir ModuleMembership_vs_GeneSignificance # in the working directory
# Calculate the module membership values (aka. module eigengene based connectivity kME):
datKME <- signedKME(datExpr, MEs)  # equals geneModuleMembership
colnames(datKME) <- sub("kME", "MM.", colnames(datKME))

colorOfColumn <- substring(names(datKME),4)
metabolites <- colnames(moduleTraitPvalue)

for (metabolite in metabolites) {
  cat(paste("\nmetabolite:", metabolite, "\n"))
  pdf(paste0("ModuleMembership_vs_GeneSignificance/", metabolite, "_ModuleMembershipVsgeneSig.pdf"))
  par(mar=c(6, 8, 4, 4) + 0.1)
  modNames = substring(names(MEs), 3)
  for (module in modNames) {
    column <- match(module,colorOfColumn)
    moduleGenes <- moduleColors == module;
    GS = paste("GS.", metabolite, sep = "")
    verboseScatterplot(abs(geneModuleMembership[moduleGenes, column]),
                       abs(geneTraitSignificance[moduleGenes, GS]),
                       xlab = paste("Module membership in", module, "module"),
                       ylab = paste("Gene significance for", metabolite),
                       xlim = c(0,1),
                       ylim = c(0,1),
                       main = paste("Module membership vs. gene significance\n"),
                       cex.main = 1.3,
                       cex.lab = 1.1,
                       cex.axis = 1,
                       pch = 21, 
                       col = "dark gray", 
                       bg = module)
  }
  
  dev.off()
}
#### end of loop

#=====================================================================================
#
#  Code chunk 6 
#
#=====================================================================================

names(datExpr)

#=====================================================================================
#
#  Code chunk 7
#
#=====================================================================================
# Create the starting data frame
geneInfo0 = data.frame(substanceBXH = probes,
                       geneSymbol = annot$gene_symbol[probes2annot],
                       LocusLinkID = annot$LocusLinkID[probes2annot],
                       moduleColor = moduleColors,
                       geneTraitSignificance,
                       GSPvalue)
# Order modules by their significance for weight
modOrder = order(-abs(cor(MEs, weight, use = "p")));
# Add module membership information in the chosen order
for (mod in 1:ncol(geneModuleMembership))
{
  oldNames = names(geneInfo0)
  geneInfo0 = data.frame(geneInfo0, geneModuleMembership[, modOrder[mod]], 
                         MMPvalue[, modOrder[mod]]);
  names(geneInfo0) = c(oldNames, paste("MM.", modNames[modOrder[mod]], sep=""),
                       paste("p.MM.", modNames[modOrder[mod]], sep=""))
}
# Order the genes in the geneInfo variable first by module color, then by geneTraitSignificance
geneOrder = order(geneInfo0$moduleColor, -abs(geneInfo0$GS.weight));
geneInfo = geneInfo0[geneOrder, ]

#=====================================================================================
#
#  Code chunk 8
#
#=====================================================================================

write.csv(geneInfo, file = "geneInfo.csv")

# It is possible to inspect the geneInfo directly within R using the command fix(geneInfo).
# Needs a lot of memory so might be slow!
#fix(geneInfo)


############################## PART 4. Interfacing network analysis with other data such as functional annotation and gene ontology

#=====================================================================================
#
#  Code chunk 1 ### SKIP
#
#=====================================================================================

# Display the current working directory
getwd();
# If necessary, change the path below to the directory where the data files are stored. 
# "." means current directory. On Windows use a forward slash / instead of the usual \.
workingDir = ".";
setwd(workingDir); 
# Load the WGCNA package
library(WGCNA)
# The following setting is important, do not omit.
options(stringsAsFactors = FALSE);
# Load the expression and trait data saved in the first part
lnames = load(file = "FemaleLiver-01-dataInput.RData");
#The variable lnames contains the names of loaded variables.
lnames
# Load network data saved in the second part.
lnames = load(file = "FemaleLiver-02-networkConstruction-auto.RData");
lnames

#=====================================================================================
#
#  Code chunk 2
#
#=====================================================================================
# 4.a Output gene lists for use with online software and services

# Read in the probe annotation
annot = read.csv(file = "GeneAnnotation.csv");
# Match probes in the data set to the probe IDs in the annotation file 
probes = names(datExpr)
probes2annot = match(probes, annot$substanceBXH)
# Get the corresponding Locuis Link IDs
allLLIDs = annot$LocusLinkID[probes2annot];
# $ Choose interesting modules
intModules = c("brown", "red", "salmon")
for (module in intModules)
{
  # Select module probes
  modGenes = (moduleColors==module)
  # Get their entrez ID codes
  modLLIDs = allLLIDs[modGenes];
  # Write them into a file
  fileName = paste("LocusLinkIDs-", module, ".txt", sep="");
  write.table(as.data.frame(modLLIDs), file = fileName,
              row.names = FALSE, col.names = FALSE)
}
# As background in the enrichment analysis, we will use all probes in the analysis.
fileName = paste("LocusLinkIDs-all.txt", sep="");
write.table(as.data.frame(allLLIDs), file = fileName,
            row.names = FALSE, col.names = FALSE)

#=====================================================================================
#
#  Code chunk 3
#
#=====================================================================================
# 4.b Enrichment analysis directly with GO.db pakg
GOenr = GOenrichmentAnalysis(moduleColors, allLLIDs, organism = "mouse", nBestP = 10);

#=====================================================================================
#
#  Code chunk 4
#
#=====================================================================================

tab = GOenr$bestPTerms[[4]]$enrichment
# This is an enrichment table containing the 10 best terms for each module present in moduleColors.

#=====================================================================================
#
#  Code chunk 5
#
#=====================================================================================

# Names of the columns within the table can be accessed by:
names(tab)

#=====================================================================================
#
#  Code chunk 6
#
#=====================================================================================

write.table(tab, file = "GOEnrichmentTable.csv", sep = ",", quote = TRUE, row.names = FALSE)

#=====================================================================================
#
#  Code chunk 7
#
#=====================================================================================

keepCols = c(1, 2, 5, 6, 7, 12, 13);
screenTab = tab[, keepCols];
# Round the numeric columns to 2 decimal places:
numCols = c(3, 4);
screenTab[, numCols] = signif(apply(screenTab[, numCols], 2, as.numeric), 2)
# Truncate the the term name to at most 40 characters
screenTab[, 7] = substring(screenTab[, 7], 1, 40)
# Shorten the column names:
colnames(screenTab) = c("module", "size", "p-val", "Bonf", "nInTerm", "ont", "term name");
rownames(screenTab) = NULL;
# Set the width of R's output. The reader should play with this number to obtain satisfactory output.
options(width=95)
# Finally, display the enrichment table:
screenTab

############################## PART 5. Network visualization using WGCNA functions:

#=====================================================================================
#
#  Code chunk 1  #### SKIP
#
#=====================================================================================

# Display the current working directory
getwd();
# If necessary, change the path below to the directory where the data files are stored. 
# "." means current directory. On Windows use a forward slash / instead of the usual \.
workingDir = ".";
setwd(workingDir); 
# Load the WGCNA package
library(WGCNA)
# The following setting is important, do not omit.
options(stringsAsFactors = FALSE);
# Load the expression and trait data saved in the first part
lnames = load(file = "FemaleLiver-01-dataInput.RData");
#The variable lnames contains the names of loaded variables.
lnames
# Load network data saved in the second part.
lnames = load(file = "FemaleLiver-02-networkConstruction-auto.RData");
lnames
nGenes = ncol(datExpr)
nSamples = nrow(datExpr)


#=====================================================================================
#
#  Code chunk 2
#
#=====================================================================================

# Calculate topological overlap anew: this could be done more efficiently by saving the TOM
# calculated during module detection, but let us do it again here.
dissTOM = 1-TOMsimilarityFromExpr(datExpr, power = 6);
# Transform dissTOM with a power to make moderately strong connections more visible in the heatmap
plotTOM = dissTOM^7;
# Set diagonal to NA for a nicer plot
diag(plotTOM) = NA;
# Call the plot function
sizeGrWindow(9,9)
TOMplot(plotTOM, geneTree, moduleColors, main = "Network heatmap plot, all genes")


#=====================================================================================
#
#  Code chunk 3
#
#=====================================================================================

nSelect = 400
# For reproducibility, we set the random seed
set.seed(10);
select = sample(nGenes, size = nSelect);
selectTOM = dissTOM[select, select];
# There's no simple way of restricting a clustering tree to a subset of genes, so we must re-cluster.
selectTree = hclust(as.dist(selectTOM), method = "average")
selectColors = moduleColors[select];
# Open a graphical window
sizeGrWindow(9,9)
# Taking the dissimilarity to a power, say 10, makes the plot more informative by effectively changing 
# the color palette; setting the diagonal to NA also improves the clarity of the plot
plotDiss = selectTOM^7;
diag(plotDiss) = NA;
TOMplot(plotDiss, selectTree, selectColors, main = "Network heatmap plot, selected genes")

#=====================================================================================
#
#  Code chunk 4
#
#=====================================================================================
# 5.b Visualizing the network of eigengenes

# Recalculate module eigengenes
MEs = moduleEigengenes(datExpr, moduleColors)$eigengenes
# Isolate weight from the clinical traits
weight = as.data.frame(datTraits$weight_g);
names(weight) = "weight"
# Add the weight to existing module eigengenes
MET = orderMEs(cbind(MEs, weight))
# Plot the relationships among the eigengenes and the trait
sizeGrWindow(5,7.5);
par(cex = 0.9)
plotEigengeneNetworks(MET, "", marDendro = c(0,4,1,2), marHeatmap = c(3,4,1,2), cex.lab = 0.8, xLabelsAngle
                      = 90)

#=====================================================================================
#
#  Code chunk 5
#
#=====================================================================================

# Plot the dendrogram
sizeGrWindow(6,6);
par(cex = 1.0)
plotEigengeneNetworks(MET, "Eigengene dendrogram", marDendro = c(0,4,2,0),
                      plotHeatmaps = FALSE)
# Plot the heatmap matrix (note: this plot will overwrite the dendrogram plot)
par(cex = 1.0)
plotEigengeneNetworks(MET, "Eigengene adjacency heatmap", marHeatmap = c(3,4,2,2),
                      plotDendrograms = FALSE, xLabelsAngle = 90)


############################## PART 6. Export of networks to external software:

#=====================================================================================
#
#  Code chunk 1  #### SKIP
#
#=====================================================================================

# Display the current working directory
getwd();
# If necessary, change the path below to the directory where the data files are stored. 
# "." means current directory. On Windows use a forward slash / instead of the usual \.
workingDir = ".";
setwd(workingDir); 
# Load the WGCNA package
library(WGCNA)
# The following setting is important, do not omit.
options(stringsAsFactors = FALSE);
# Load the expression and trait data saved in the first part
lnames = load(file = "FemaleLiver-01-dataInput.RData");
#The variable lnames contains the names of loaded variables.
lnames
# Load network data saved in the second part.
lnames = load(file = "FemaleLiver-02-networkConstruction-auto.RData");
lnames

#=====================================================================================
#
#  Code chunk 2   ### SKIP
#
#=====================================================================================

# Recalculate topological overlap
TOM = TOMsimilarityFromExpr(datExpr, power = 6);
# Read in the annotation file
annot = read.csv(file = "GeneAnnotation.csv");
# Select module
module = "brown";
# Select module probes
probes = names(datExpr)
inModule = (moduleColors==module);
modProbes = probes[inModule];
# Select the corresponding Topological Overlap
modTOM = TOM[inModule, inModule];
dimnames(modTOM) = list(modProbes, modProbes)
# Export the network into an edge list file VisANT can read
vis = exportNetworkToVisANT(modTOM,
                            file = paste("VisANTInput-", module, ".txt", sep=""),
                            weighted = TRUE,
                            threshold = 0,
                            probeToGene = data.frame(annot$substanceBXH, annot$gene_symbol) )


#=====================================================================================
#
#  Code chunk 3    ### SKIP
#
#=====================================================================================


nTop = 30;
IMConn = softConnectivity(datExpr[, modProbes]);
top = (rank(-IMConn) <= nTop)
vis = exportNetworkToVisANT(modTOM[top, top],
                            file = paste("VisANTInput-", module, "-top30.txt", sep=""),
                            weighted = TRUE,
                            threshold = 0,
                            probeToGene = data.frame(annot$substanceBXH, annot$gene_symbol) )


#=====================================================================================
#
#  Code chunk 4         CYTOSCAPE
#
#=====================================================================================
# 6.b Exporting to Cytoscape

# Recalculate topological overlap if needed
TOM = TOMsimilarityFromExpr(datExpr, power = 6);
# Read in the annotation file
annot = read.csv(file = "GeneAnnotation.csv");
# Select modules
modules = c("brown", "red");
# Select module probes
probes = names(datExpr)
inModule = is.finite(match(moduleColors, modules));
modProbes = probes[inModule];
modGenes = annot$gene_symbol[match(modProbes, annot$substanceBXH)];
# Select the corresponding Topological Overlap
modTOM = TOM[inModule, inModule];
dimnames(modTOM) = list(modProbes, modProbes)
# Export the network into edge and node list files Cytoscape can read
cyt = exportNetworkToCytoscape(modTOM,
                               edgeFile = paste("CytoscapeInput-edges-", paste(modules, collapse="-"), ".txt", sep=""),
                               nodeFile = paste("CytoscapeInput-nodes-", paste(modules, collapse="-"), ".txt", sep=""),
                               weighted = TRUE,
                               threshold = 0.02,
                               nodeNames = modProbes,
                               altNodeNames = modGenes,
                               nodeAttr = moduleColors[inModule]);
