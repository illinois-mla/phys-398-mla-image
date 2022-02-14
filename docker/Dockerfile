ARG BASE_IMAGE=jupyter/minimal-notebook:lab-3.2.8
FROM ${BASE_IMAGE} as base

USER root

# ffmpeg for matplotlib anim & dvipng for latex labels
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg dvipng && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /home/jovyan/work

USER ${NB_UID}

COPY docker/jupyter_notebook_config.py /etc/jupyter/
COPY docker/requirements.txt /requirements.txt

# Following https://github.com/jupyter/docker-stacks/blob/9b87b16254455fdff2eb7884a424eb19f5aba496/scipy-notebook/Dockerfile
# PrairieLearn seems to need port 8080 to work, so ensure that both /etc/jupyter/jupyter_notebook_config.py
# and /etc/jupyter/jupyter_server_config.py have 8080 and not 8888
#
# Use Brett Cannon's recommendations for pip-secure-install to ensure environment
# is reproducible and installed as securely as possible.
# c.f. https://www.python.org/dev/peps/pep-0665/#secure-by-design
# c.f. https://github.com/brettcannon/pip-secure-install
# c.f. https://twitter.com/brettsky/status/1486137764315688961
# exceptions need to be made for some libraries which only ship sdists, these
# libraries are explicitly named in --no-binary to allow for installation from
# sdist.
RUN mkdir -p "/home/${NB_USER}/.local" && \
    cp /requirements.txt "/home/${NB_USER}/.local/requirements.txt" && \
    python -m pip --no-cache-dir install --upgrade pip setuptools wheel && \
    python -m pip --no-cache-dir install 'pip-tools>=6.5.0' && \
    python -m piptools compile \
        --generate-hashes \
        --output-file "/home/${NB_USER}/.local/requirements.lock" \
        "/home/${NB_USER}/.local/requirements.txt" && \
    python -m pip --no-cache-dir install \
        --no-deps \
        --require-hashes \
        --only-binary :all: \
        --no-binary termcolor,jax,wpca \
        --requirement "/home/${NB_USER}/.local/requirements.lock" && \
    conda clean --all -f -y && \
    jupyter lab clean -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}" && \
    grep -rl "8888" /etc/jupyter | xargs sed -i 's/8888/8080/g'

WORKDIR ${HOME}

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions "/home/${NB_USER}"

CMD ["start.sh", "jupyter", "lab"]
