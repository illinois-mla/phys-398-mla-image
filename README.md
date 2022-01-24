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

## Use

To run the Docker image as a container with persistence of any files that are generated in the environment, you can bind mount your current working directory to the working directory inside of the container and expose the port `8080`

```
docker run --rm -ti -v $PWD:/home/jovyan/work -w /home/jovyan/work -p 8080:8080 physicsillinois/phys-398-mla:spring-2022
```
