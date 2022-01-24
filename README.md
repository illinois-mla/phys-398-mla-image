# PHYS 398 MLA Docker Image

Docker image for the PHYS 398 MLA used to power the [PrairieLearn workspaces](https://prairielearn.readthedocs.io/en/latest/workspaces/).

[![Docker Images](https://github.com/illinois-mla/phys-398-mla-image/actions/workflows/docker.yml/badge.svg?branch=main)](https://github.com/illinois-mla/phys-398-mla-image/actions/workflows/docker.yml?query=branch%3Amain)
[![Docker Pulls](https://img.shields.io/docker/pulls/physicsillinois/phys-398-mla)](https://hub.docker.com/r/physicsillinois/phys-398-mla)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/physicsillinois/phys-398-mla/latest)](https://hub.docker.com/r/physicsillinois/phys-398-mla/tags?name=latest)

## Installation

- Check the [list of available tags on Docker Hub](https://hub.docker.com/r/physicsillinois/phys-398-mla/tags?page=1) to find the tag you want.
- Use `docker pull` to pull down the image corresponding to the tag. For example:

```
docker pull physicsillinois/phys-398-mla:latest
```

### Spring 2022

Use the `spring-2022` tag of the Docker image

```
docker pull physicsillinois/phys-398-mla:spring-2022
```

## Use

To run the Docker image as a container with persistence of any files that are generated in the environment, you can bind mount your current working directory to the working directory inside of the container and expose the port `8080`

```
docker run --rm -ti -v $PWD:/home/jovyan/work -w /home/jovyan/work -p 8080:8080 physicsillinois/phys-398-mla:spring-2022
```

this will then start a JupyterLab server instance, which you can open up on your local browser by visiting the url `http://localhost:8080/lab`.

Any files that exist in your current working directory will be available inside of the Docker image in your JupyterLab environment, and any files you create inside the JupyterLab environment will be saved in your current working directory.

### Optional easy way

If you want to use a simple Bash script that will do this for you, you can first just download the `run_jupyter_standalone.sh` script from this repo with something like

```
curl -sLO https://raw.githubusercontent.com/illinois-mla/phys-398-mla-image/main/run_jupyter_standalone.sh
```

and then run it from the directory with your notebook you'd like to run

```
bash run_jupyter_standalone.sh
```

## Interactive Jupyter widgets

The image has support for Jupyter widgets enabled, like [`ipympl`][ipyml-github], that allow for interactive elements to be used.

[ipyml-github]: https://github.com/matplotlib/ipympl

### Simple Example

Enable [`ipympl`][ipyml-github] for interactive `matplotlib` visualizations in your Jupyter notebook

```python
%matplotlib widget  # Enable matplotlib Jupyter widget

import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(0, 10, 1000)
y = np.sin(x)

fig, ax = plt.subplots()
ax.plot(x, y)
```
