ARG BASE_IMAGE=jupyter/minimal-notebook:latest
FROM ${BASE_IMAGE} as base

USER root

# ffmpeg for matplotlib anim & dvipng for latex labels
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg dvipng && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /home/jovyan/work

USER ${NB_UID}

# COPY docker/jupyter_notebook_config.py /etc/jupyter/
COPY docker/requirements.txt /requirements.txt

# Following https://github.com/jupyter/docker-stacks/blob/9b87b16254455fdff2eb7884a424eb19f5aba496/scipy-notebook/Dockerfile
# RUN mkdir -p "/home/${NB_USER}/.local" && \
#     cp /requirements.txt "/home/${NB_USER}/.local/requirements.txt" && \
#     python -m pip --no-cache-dir install  --upgrade pip setuptools wheel && \
#     python -m pip --no-cache-dir install pip-tools && \
#     python -m piptools compile \
#         --generate-hashes \
#         --output-file "/home/${NB_USER}/.local/requirements.lock" \
#         "/home/${NB_USER}/.local/requirements.txt" && \
#     python -m pip install --requirement "/home/${NB_USER}/.local/requirements.lock" && \
#     conda clean --all -f -y && \
#     echo "# Activate ipywidgets extension in the environment that runs the notebook server" && \
#     jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
#     echo "# Also activate ipywidgets extension for JupyterLab" && \
#     jupyter lab build -y && \
#     jupyter lab clean -y && \
#     fix-permissions "${CONDA_DIR}" && \
#     fix-permissions "/home/${NB_USER}"

RUN mkdir -p "/home/${NB_USER}/.local" && \
    cp /requirements.txt "/home/${NB_USER}/.local/requirements.txt" && \
    python -m pip --no-cache-dir install  --upgrade pip setuptools wheel && \
    python -m pip --no-cache-dir install pip-tools && \
    python -m piptools compile \
        --generate-hashes \
        --output-file "/home/${NB_USER}/.local/requirements.lock" \
        "/home/${NB_USER}/.local/requirements.txt" && \
    python -m pip install --requirement "/home/${NB_USER}/.local/requirements.lock" && \
    conda clean --all -f -y && \
    # Activate ipywidgets extension in the environment that runs the notebook server
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    # Also activate ipywidgets extension for JupyterLab
    # Check this URL for most recent compatibilities
    # https://github.com/jupyter-widgets/ipywidgets/tree/master/packages/jupyterlab-manager
    jupyter labextension install @jupyter-widgets/jupyterlab-manager@^2.0.0 --no-build && \
    jupyter labextension install jupyter-matplotlib@^0.7.2 --no-build && \
    jupyter lab build -y && \
    jupyter lab clean -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

WORKDIR ${HOME}

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions "/home/${NB_USER}"

CMD ["start.sh", "jupyter", "lab"]
