# Developing the Docker image

## Base image

To simplify things, the base image used is `jupyter/minimal-notebook:lab-3.2.8` which is maintained by the Jupyter team to provide a minimal environment for being able to run Jupyter Lab in an interactive mode from inside the container.
Updating this base image tag can result in the CPython runtime changing in addition to other dependencies, so it should only be changed if the entire environment is going to be rebuilt.

## Python environment

The Python environment that exists inside of the Docker image is described at a high level by a `requirements.txt` file, and is fully described at the hash level by a `requirements.lock` generated with `pip-compile` from [`pip-tools`][pip-tools].

### High level requirements.txt

A developer should control the environment by describing the high level dependencies they need in the `requirements.txt`.
These dependencies will be the things that will actually be imported by the intended users (e.g. `pandas` and `matplotlib`) and not the dependencies of those imports.
To make things more stable and reproducible the dependencies in the `requirements.txt` should all be fully pinned (i.e., for a SemVer package fully specified down to the patch release).

While it may be possible for the intended code to work in an environment that provides a less complete description, e.g. using [compatible release syntax][PEP 440] (`~=`) to pin down only to the minor release, the computing environment should be viewed as [an application][application vs library] &mdash; the goal is runtime stability for existing code.

### Lock file

To create a full description of the environment the high level `requirements.txt` can be "compiled" into a `requirements.lock` lock file that lists all libraries and all of their dependencies pinned at the hash level using [`pip-tools`][pip-tools].
The lock file is designed to make the computing environment as fully reproducible as possible. Given the complexity of the dependency solve that might be necessary to meet all dependency requirements, the lock file should not be edited by hand at all and should only be created or updated through use of `pip-tools`'s `pip-compile` command.
The lock file should be kept under version control though so that any build of the Docker image's environment is fully reproducible in the future.

## Updating the environment

The lock file is compiled from the `requirements.txt` using `pip-compile`

https://github.com/illinois-mla/phys-398-mla-image/blob/aa73f8b3e74125552b6cbb23220f8d1a56e37f69/docker/compile_dependencies.sh#L10-L13

A helper script `compile_dependencies.sh` is provided inside of the `docker` directory that can be run inside of a Python virtual environment

```console
bash compile_dependencies.sh
```

to produce the lock file that would be generated for that version of CPython.

To update the Python environment, a developer should:

1. Add to or revise the dependencies defined in the high level `requirements.txt`.
2. Compile the `requirements.lock` lock file from the updated `requirements.txt` using `compile_dependencies.sh`.
3. Commit both the updated `requirements.txt` and `requirements.lock` to version control.
4. Rebuild the Docker image with the updated files.

## Installing the environment

The lock file provides the _capability_ for a fully reproducible environment, but to truly ensure it is reproducible it needs to be installed in a secure method as well.
A good way to do this is to implement [Brett Cannon][Brett Cannon]'s "[secure-install][pip-secure-install]" procedure with `pip`.
The options that are enabled to have `pip` take advantage of the lock file are described in the following section taken from the [GitHub Action implementation][pip-secure-install].

> ## Design
>
> A few options are turned on for pip to make sure [installations are secure](https://www.python.org/dev/peps/pep-0665/#secure-by-design) and reproducible:
>
> - A requirements file must be specified to make sure all dependencies are known
>   statically for auditing purposes (`-r`).
> - No dependency resolution is done to make sure the requirements file is
>   complete (`--no-deps`).
> - All requirements must have a hash provided to make sure the files have not
>   been tampered with (`--require-hashes`).
> - Only wheels are allowed to have reproducible installs (`--only-binary :all:`).

## Updating the tagged Docker images

The Docker image will be built automatically and deployed to [Docker Hub][Docker Hub] through CI/CD with GitHub Actions.
To avoid accidentally overwriting a course tag with a new build the tag procedure is manual for the time being.

1. After a build has successfully finished and deployed to Docker Hub pull it down locally
```
physicsillinois/phys-398-mla:latest
```
2. Tag the pulled image with the course tag you want to distribute (e.g. `spring-2022`)
```
docker tag physicsillinois/phys-398-mla:latest physicsillinois/phys-398-mla:<new tag goes here>
```
3. Push the new tag to Docker Hub. This will be very fast as the digest of the image layers already exist on Docker Hub and it will recognize this and just associate a new tag to them instead of pushing the full image.
```
docker push physicsillinois/phys-398-mla:<new tag goes here>
```

It is recommended after this that you clean up your Docker image cache with

```
docker system prune
```

If you are working with Docker locally on a regular basis you probably want to do this at least daily.

[pip-tools]: https://pip-tools.rtfd.io/
[PEP 440]: https://peps.python.org/pep-0440/
[application vs library]: https://iscinumpy.dev/post/app-vs-library/
[Brett Cannon]: https://github.com/brettcannon
[pip-secure-install]: https://github.com/brettcannon/pip-secure-install
[Docker Hub]: https://hub.docker.com/r/physicsillinois/phys-398-mla
