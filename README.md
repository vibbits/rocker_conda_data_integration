[![license](https://img.shields.io/badge/license-GPLv2-blue.svg)](https://opensource.org/licenses/GPL-2.0)

In order to start working with the data integration tools container, we need to install Docker. 

# Install Docker

Depending on your operating system:
- Docker For Mac users (https://docs.docker.com/docker-for-mac/):

Ensure your versions of docker, docker-compose, and docker-machine are up-to-date and compatible with Docker.app. 
Your output may differ if you are running different versions.
```
$ docker --version
Docker version 18.03, build c97c6d6

$ docker-compose --version
docker-compose version 1.23.1, build 8dd22a9

$ docker-machine --version
docker-machine version 0.14.0, build 9ba6da9
```
 
- Docker for Windows users (https://docs.docker.com/docker-for-windows/):
1. Open a terminal window (Command Prompt or PowerShell, but not PowerShell ISE).
2. Run ```$ docker --version``` to ensure that you have a supported version of Docker:
```
> docker --version
Docker version 18.03.0-ce, build 0520e24
```
- Docker for Linux users - follow the instructions on the link: https://docs.docker.com/install/linux/docker-ce/ubuntu/
To get started with Docker CE on Ubuntu, make sure you meet the prerequisites (https://docs.docker.com/install/linux/docker-ce/ubuntu/#prerequisites)
and then install docker (https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce).

# rocker_conda_data_integration
Docker container on rocker/tidyverse with miniconda3 to run various  data integration tools

  *  MOFA tool https://github.com/bioFAM/MOFA
  *  mixOmics [http://mixomics.org/](http://mixomics.org/)
  *  WGCNA [WGCNA at Horvath Lab](https://labs.genetics.ucla.edu/horvath/CoexpressionNetwork/Rpackages/WGCNA/)

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
docker run -e PASSWORD=yourpassword -p 8787:8787 -v $(pwd):/home/rstudio/kitematic vibbioinfocore/rocker_conda_data_integration
```

On your host, it is using the current working directory as reference folder and maps it to the folder /home/rstudio/kitematic within the container. Note: on the specified folder on your host, you have to have read and write access.

Once you have started the docker instance, you are ready to go by surfing to http://localhost:8787 or eventually http://0.0.0.0:8787 - the login is rstudio and the chosen password.

You can now start the vignette e.g. the [single cell data vignette](https://github.com/bioFAM/MOFA/blob/master/MOFAtools/vignettes/MOFA_example_scMT.Rmd)

There are two important settings which you have to adapt so that it works fine in the container.

The variable outfile of the list DirOptions should be set to ``` /home/rstudio/kitematic/<name of model>.hdf5```. In this case, the model file is written to the directory specified when starting the container. In our case this is the current working directory but we specify the folder within the container in DirOptions!

```
DirOptions <- list(
  "dataDir" = tempdir(), # Directory to store the input matrices as .txt files, it can be a temporary folder
  "outFile" = "/home/rstudio/kitematic/model.hdf5" # Output file of the model (use hdf5 extension)
)
```
Now, MOFA should run and create the hdf5 file in the specified directory.

For MixOmics:
Please visit their web site for a comprehensive overview: [http://mixomics.org/](http://mixomics.org/)
Example scripts can be downloaded [here](http://journals.plos.org/ploscompbiol/article/file?type=supplementary&id=info:doi/10.1371/journal.pcbi.1005752.s002)

For WGCNA:

A tutorial can be found [here](https://horvath.genetics.ucla.edu/html/CoexpressionNetwork/Rpackages/WGCNA/Tutorials/)
