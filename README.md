[![license](https://img.shields.io/badge/license-GPLv2-blue.svg)](https://opensource.org/licenses/GPL-2.0)

# rocker_conda_data_integration
Docker container on rocker/tidyverse with miniconda3 to run various  data integration tools

  *  MOFA tool https://github.com/bioFAM/MOFA
  *  mixOmics 
  *  WGCNA

Visit [rocker-project.org](http://rocker-project.org) for more about available Rocker images, configuration, and use.

A very short how-to here to lauch the container.

Getting Started

Ensure you have [Docker](https://www.docker.com/) installed and get started with the RStudio® based instance:

```
docker run --rm -p 8787:8787 vibbioinfocore/rocker_conda_data_integration
```

Then, point your browser to http://localhost:8787. Log in with user/password rstudio/rstudio.

With this command you will only be able to explore the environment but not yet run the tools successfully. 

For MOFA:
In order to run the complete vignette of MOFA, you have to define a folder on your host where MOFA will write the hdf5 file to.

So it is recommended to start the Docker instance like this:

```
docker run -p 8787:8787 -v $(pwd):/home/rstudio/kitematic vibbioinfocore/rocker_conda_data_integration
```

On your host, it is using the current working directory as reference folder and maps it to the folder /home/rstudio/kitematic within the container. Note: on the specified folder on your host, you have to have read and write access.

Once you have started the docker instance, you are ready to go by surfing to http://localhost:8787 or eventually http://0.0.0.0:8787 - the login is rstudio and the password rstudio.

You can now start the vignette e.g. the [single cell data vignette](https://github.com/bioFAM/MOFA/blob/master/MOFAtools/vignettes/MOFA_example_scMT.Rmd)

There are two important settings which you have to adapt so that it works fine in the container.

The variable outfile of the list DirOptions should be set to ``` /home/rstudio/kitematic/<name of model>.hdf5```. In this case, the model file is written to the directory specified when starting the container. In our case this is the current working directory but we specify the folder within the container in DirOptions!

```R
DirOptions <- list(
  "dataDir" = tempdir(), # Directory to store the input matrices as .txt files, it can be a temporary folder
  "outFile" = "/home/rstudio/kitematic/model.hdf5" # Output file of the model (use hdf5 extension)
)
```
Further in the vignette, you can launch the MOFA run on the example dataset. In order to run MOFA from within the RStudio®, you have to specify the location of the exectable, in our case in the container. It is ```/opt/conda/bin/mofa```

```R
MOFAobject <- runMOFA(MOFAobject, DirOptions, mofaPath = "/opt/conda/bin/mofa")
```
Now, MOFA should run and create the hdf5 file in the specified directory.

For MixOmics:
Please visit their web site for a comprehensive overview: [http://mixomics.org/](http://mixomics.org/)
Example scripts can be downloaded [here](http://journals.plos.org/ploscompbiol/article/file?type=supplementary&id=info:doi/10.1371/journal.pcbi.1005752.s002)

For WGCNA:

A tutorial can be found [here](https://labs.genetics.ucla.edu/horvath/CoexpressionNetwork/Rpackages/WGCNA/Tutorials/)
