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

Once you have started the docker instance, you are ready to go by surfing to http://localhost:8787 or eventually http://0.0.0.0:8787 - the login is rstudio and the chosen password.

For WGCNA:

A tutorial can be found [here](https://horvath.genetics.ucla.edu/html/CoexpressionNetwork/Rpackages/WGCNA/Tutorials/)

For MixOmics:
Please visit their web site for a comprehensive overview: [http://mixomics.org/](http://mixomics.org/)
Example scripts can be downloaded [here](http://journals.plos.org/ploscompbiol/article/file?type=supplementary&id=info:doi/10.1371/journal.pcbi.1005752.s002)

For MOFA:
In order to run the complete vignette of MOFA, you have to define a folder on your host where MOFA will write the hdf5 file to.

You can now start the vignette e.g. the [vignette](https://github.com/vibbits/rocker_conda_data_integration/blob/master/MOFA_vignette_course.R)
