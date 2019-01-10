[![license](https://img.shields.io/badge/license-GPLv2-blue.svg)](https://opensource.org/licenses/GPL-2.0)

In order to start working with the data integration tools container, we need to install Docker. 

# Install Docker

Depending on your operating system:
- Docker for Mac: https://download.docker.com/mac/stable/Docker.dmg

  Please note that macOS El Capitan 10.11 and newer macOS releases are supported.
  
  System Requirements:
  
  - Mac hardware must be a 2010 or newer model, with Intel’s hardware support for memory management unit (MMU) virtualization, including     Extended Page Tables (EPT) and Unrestricted Mode. 
    You can check to see if your machine has this support by running the following   command in a terminal: ```sysctl kern.hv_support```

   - macOS El Capitan 10.11 and newer macOS releases are supported. We recommend upgrading to the latest version of macOS.

   - At least 4GB of RAM

  More detailed information: https://docs.docker.com/docker-for-mac/install/

- Docker for Windows 10: https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe
  
  Please note that only Windows 10 can be used for easy installation and use of Docker.
  
  System Requirements:

  - Windows 10 64bit: Pro, Enterprise or Education (1607 Anniversary Update, Build 14393 or later).
  - Virtualization is enabled in BIOS. Typically, virtualization is enabled by default. This is different from having Hyper-V enabled.       For more detail see Virtualization must be enabled in Troubleshooting.
  - CPU SLAT-capable feature.
  - At least 4GB of RAM.
  
  More detailed information: https://docs.docker.com/docker-for-windows/install/#install-docker-for-windows-desktop-app

- Docker for Linux
  
    (https://docs.docker.com/install/linux/docker-ce/)
  
   Please choose your distribution and install accordingly: https://docs.docker.com/install/#supported-platforms
   
   Make sure you meet the prerequisites depending on your distribution.
   
   After the installation, it is recommended to execute the post-installation steps
   https://docs.docker.com/install/linux/linux-postinstall/
   
   More detailed information: https://docs.docker.com/install/ - Linux

# Testing Docker 

Depending on your operating system:
- Docker For Mac users (https://docs.docker.com/docker-for-mac/):

Ensure your versions of docker, docker-compose, and docker-machine are up-to-date and compatible with Docker.app. 
Your output may differ if you are running different versions.
1. Open a terminal window
2. Run ```$ docker --version```

```
$ docker --version
Docker version 18.03, build c97c6d6
```
 
- Docker for Windows users (https://docs.docker.com/docker-for-windows/):
1. Open a terminal window (Command Prompt or PowerShell, but not PowerShell ISE).
2. Run ```$ docker --version``` 

```
> docker --version
Docker version 18.03.0-ce, build 0520e24
```
- Docker for Linux users 
1. Open a terminal window
2. Run ```$ docker --version``` 

```
$ docker --version
Docker version 18.03, build c97c6d6
```

# Download the docker image 

Please download the docker image before the course starts on a decent internet connection.

```
$ docker pull vibbioinfocore/rocker_conda_data_integration
Using default tag: latest
latest: Pulling from vibbioinfocore/rocker_conda_data_integration
bc9ab73e5b14: Pull complete
3814c169951f: Downloading  72.74MB/204.1MB
d999dec28536: Downloading  84.45MB/121.8MB
b95261c34bf8: Download complete
2c91e5097c75: Download complete
c940c00fa4eb: Download complete
89cfad18442b: Download complete
fae537f62da1: Downloading  31.26MB/318.5MB
383081f8b856: Waiting
7c696f938105: Waiting
595617aff784: Waiting
0cdb16a07490: Waiting
1ad598452570: Waiting
a88f491207a2: Waiting
f418c6738bfe: Waiting
```
after a while you will see

```
$ docker pull vibbioinfocore/rocker_conda_data_integration
Using default tag: latest
latest: Pulling from vibbioinfocore/rocker_conda_data_integration
bc9ab73e5b14: Pull complete
3814c169951f: Pull complete
d999dec28536: Pull complete
b95261c34bf8: Pull complete
2c91e5097c75: Pull complete
c940c00fa4eb: Pull complete
89cfad18442b: Pull complete
fae537f62da1: Pull complete
383081f8b856: Pull complete
7c696f938105: Pull complete
595617aff784: Pull complete
0cdb16a07490: Pull complete
1ad598452570: Pull complete
a88f491207a2: Pull complete
f418c6738bfe: Pull complete
Digest: sha256:86303d2766ab5dd75698f97e8427f41ab104f2ba7d5db9c771c0e31c9610ea12
Status: Downloaded newer image for vibbioinfocore/rocker_conda_data_integration:latest
```

On Windows, it is possible that you get an error message when you launch the pull command. It complains about the fact that 
our container is 'linux' based and cannot be run on Windows.
Please check the setting described here: https://docs.docker.com/docker-for-windows/#switch-between-windows-and-linux-containers

Furthermore, the Windows user (the one you log in to the computer) should be member of the User group 'Docker Users' - please see here: 
You need to add your logon account to Windows group, docker-users. Docker for Window will create this group automatically when docker for Windows is installed.
```
Steps:

Logon to Windows as Administrator
Go to Windows Administrator Tools
Look for Windows Computer Management and click on it.
Or you can skip steps 1, right mouse clicking Computer Management, go to more, and select run as administrator and provide Administrator password.
Double click docker-users group and add your account as member.
Log off from Windows and log back on as normal user.
```


# About the tutorial with the container rocker_conda_data_integration
Docker container on rocker/tidyverse with miniconda3 to run various  data integration tools

  *  MOFA tool https://github.com/bioFAM/MOFA
  *  mixOmics [http://mixomics.org/](http://mixomics.org/)
  *  WGCNA [WGCNA at Horvath Lab](https://labs.genetics.ucla.edu/horvath/CoexpressionNetwork/Rpackages/WGCNA/)

Visit [rocker-project.org](http://rocker-project.org) for more about available Rocker images, configuration, and use.

A very short how-to here to lauch the container.

Getting Started

Ensure you have [Docker](https://www.docker.com/) installed and get started with the RStudio® based instance:

```
docker run -e PASSWORD=yourpassword --rm -p 8787:8787 vibbioinfocore/rocker_conda_data_integration
```

Then, point your browser to http://localhost:8787. Log in with user/password rstudio/yourpassword

With this command you will only be able to explore the environment but not yet run the tools successfully. 

So it is recommended to start the Docker instance in a command prompt or terminal window:

For Mac and Linux:

```
docker run -e PASSWORD=yourpassword -p 8787:8787 -v $(pwd):/home/rstudio/kitematic vibbioinfocore/rocker_conda_data_integration
```

For Windows:
```
docker run -e PASSWORD=yourpassword -p 8787:8787 -v %cd%:/home/rstudio/kitematic vibbioinfocore/rocker_conda_data_integration
```

On your host, it is using the current working directory as reference folder and maps it to the folder /home/rstudio/kitematic within the container. Note: on the specified folder on your host, you have to have read and write access.

This means that you have to note down the working directory when you open the Windows command prompt or the Linux or Mac terminal.
On Windows, the current working directory is ```C:\Users\your_user_account\```. On Mac, it is ```Users/your_user_account/```.

Once you have started the docker instance, you are ready to go by surfing to http://localhost:8787 or eventually http://0.0.0.0:8787 - the login is rstudio and the chosen password.

For WGCNA:

A tutorial can be found [here](https://horvath.genetics.ucla.edu/html/CoexpressionNetwork/Rpackages/WGCNA/Tutorials/)

For MixOmics:
Please visit their web site for a comprehensive overview: [http://mixomics.org/](http://mixomics.org/)
Example scripts can be downloaded [here](http://journals.plos.org/ploscompbiol/article/file?type=supplementary&id=info:doi/10.1371/journal.pcbi.1005752.s002)

For MOFA:
In order to run the complete vignette of MOFA [vignette](http://htmlpreview.github.io/?https://github.com/bioFAM/MOFA/blob/master/MOFAtools/vignettes/MOFA_example_CLL.html),
we recommend that you download the vignette Rmd file: (https://github.com/vibbits/rocker_conda_data_integration/blob/master/MOFA_example.Rmd)

Further Analysis:
Normally the data integration process yields a list of (ranked) candidate genes (/modules/clusters). To gain further biological insights Gene Ontology and Pathway enrichments downstream analyses are desired.
To do so we added to this docker image the fgsea packge (https://github.com/ctlab/fgsea), designed for fast preranked gene set enrichment analysis (GSEA). The package implements a special algorithm to calculate the empirical enrichment score null distributions simulthaneously for all the gene set sizes, which allows up to several hundred times faster execution time compared to original Broad implementation. See the preprint for algorithmic details.

To use the fgsea, one could use the follwoing R commands: 
```
# Given ranked list of genes (e.g. derived from data integraition analysis)
# Run Gene Enrichment Set Analysis (GSEA):
fgsea_enrichment_results = c()
for(cc in names(diff_res_ttest)[3:4]){
  curr_scores = -log(diff_res_ttest[[cc]][,2])
  names(curr_scores) = sapply(names(curr_scores),function(x)strsplit(x,split="\\.")[[1]][1])
  names(curr_scores) = gene_names[names(curr_scores)]
  fgsea_enrichment_results[[cc]] = fgsea_wrapper(mm_pathway,curr_scores,nperm = 200)  
}

# PARAMs: external data used in the enrichments steps below:
mouse_genes_path = "Mus_musculus.GRCm38.94.gtf_genes_only.txt"
mouse_proteins_path = "MOUSE_10090_idmapping.dat"

# Read protein mapping info: we want uniprot to ensembl
# Data was downloaded from uniprot
raw_proteomics = read.delim(mouse_proteins_path,header = F,stringsAsFactors = F)
uniprot2ensemble_pro = raw_proteomics[raw_proteomics[,2] == "Ensembl_PRO",]
uniprot2ensemble_gene = raw_proteomics[raw_proteomics[,2] == "Ensembl",]

# for clustering, enrichment, and intepretation of results
library('gskb')
data(mm_pathway)
gene_info = read.table(mouse_genes_path,stringsAsFactors = F)
gene_names = gene_info[,16]
names(gene_names) = gene_info[,10]
gene_names = toupper(gene_names)

# An important parameter of enrichment analyses: the background set of genes.
# This should be all genes theoretically examined in an experiment.
# Example for us:
# bg = gene_names[rownames(abundance_data[["ge"]])] 
simple_enrichment_analysis<-function(set1,set2,bg){
  set1 = intersect(set1,bg)
  set2 = intersect(set2,bg)
  if(length(set1)==0 || length(set2)==0){return(1)}
  x1 = is.element(bg,set=set1)
  x2 = is.element(bg,set=set2)
  tb = table(x1,x2)
  p = fisher.test(tb,alternative = "g")$p.value
  genes = intersect(set1,set2)
  return(list(p=p,genes=genes))
}
enrichment_list_to_table<-function(l){
  ps = c()
  genes = c()
  for(j in 1:length(l)){
    ps = c(ps,l[[j]][[1]])
    currg = ""
    if(length(l[[j]])>1){
      currg = paste(l[[j]][[2]],collapse=",")
    }
    genes = c(genes,currg)
  }
  return(cbind(names(l),ps,genes))
}

# Differential abundance using simple linear regression
lm_get_effects_and_pvals<-function(y,x){
  m = lm(y~.,data=data.frame(y,x))
  m = summary(m)$coefficients
  v = c(m[-1,1],m[-1,4])
  names(v)[1:(nrow(m)-1)] = paste("effect_",names(v)[1:(nrow(m)-1)],sep="")
  names(v)[nrow(m):length(v)] = paste("pval_", names(v)[nrow(m):length(v)],sep="")
  return(v)
}

library(fgsea)
fgsea_wrapper <- function(pathways,scores,nperm=2000,run_nperm=1000,...){
  num_runs = nperm/run_nperm
  l = list()
  for(j in 1:num_runs){
    l[[j]] = fgsea(pathways,scores,nperm = run_nperm,...)
  }
  emp_pvals = sapply(l,function(x)x$pval)
  emp_pvals = emp_pvals*run_nperm
  min_to_add = min(emp_pvals)
  emp_pvals = emp_pvals-min_to_add
  new_pvals = rowSums(emp_pvals)+min_to_add
  new_pvals = new_pvals/nperm
  new_qvals = p.adjust(new_pvals,method='fdr')
  res = l[[1]]
  res[,"pval"] = new_pvals
  res[,"padj"] = new_qvals
  return(res)
}

```

