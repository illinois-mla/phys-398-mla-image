# Developing the Docker image

## Base image

To simplify things, the base image used is `jupyter/minimal-notebook:lab-3.2.8` which maintained by the Jupyter team to provide a minimal environment for being able to run Jupyter Lab in an interactive mode from inside the container.
Updating this base image tag can result in the CPython runtime changing in addition to other dependencies, so it should only be changed if the entire environment is going to be rebuilt.

## Python environment

The Python environment that exists inside of the Docker image is described at a high level by a `requirements.txt` file, and is fully described at the hash level by a `requirements.lock` generated with `pip-compile` from [`pip-tools`][pip-tools].

### High level requirements.txt

A developer should control the environment by describing the high level dependencies they need in the `requirements.txt`.
These dependencies will be the things that will actually be imported by the intended users (e.g. `pandas` and `matplotlib`) and not the dependencies of those imports.
To make things more stable and reproducible the dependencies in the `requirements.txt` should all be fully pinned (i.e., for a SemVer package fully specified down to the patch release).

While it may be possible for the intended code to work in an environment that provides a less complete description, e.g. using [compatible version syntax][PEP 440] (`~=`) to pin down only to the minor release, the computing environment should be viewed as [an application][application vs library] &mdash; the goal is runtime stability for existing code.

### Lock file

[pip-tools]: https://pip-tools.rtfd.io/
[PEP 440]: https://peps.python.org/pep-0440/
[application vs library]: https://iscinumpy.dev/post/app-vs-library/
