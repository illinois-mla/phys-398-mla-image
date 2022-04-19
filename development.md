# Developing the Docker image

## Base image

To simplify things, the base image used is `jupyter/minimal-notebook:lab-3.2.8` which maintained by the Jupyter team to provide a minimal environment for being able to run Jupyter Lab in an interactive mode from inside the container.
Updating this base image tag can result in the CPython runtime changing in addition to other dependencies, so it should only be changed if the entire environment is going to be rebuilt.

## Lock file
