# orca-extended
Docker container for BioInformatics

This is an extension of https://github.com/bcgsc/orca to provide additional services and applications for running
bioinformatics pipelines.

## Additional programs:

- jupyter
- deepTools
- macs2
- htseq
- homer (including mm10 genome)
- rstudio-server

It also includes a number of R packages useful for carrying out analysis. See [install.R](./install.R) for
a list of these.

## Execution

From source:

```
docker build -t orcaext .
docker run -p 8787:8787 -p 8888:8888 -v $HOME:$HOME -w $HOME orcaext
```

This will expose RStudio server on port 8787 and jupyter notebook on port 8888

> Please note that it takes a very long time to build and install the R packages so it is only recommended to build
> this container once per release from source.

## Logging in:

RStudio server: username `orca`, password `orcauser`
Jupyter notebook: password `orcauser`

