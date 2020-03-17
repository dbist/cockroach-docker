FROM jupyter/all-spark-notebook AS jupyterlab
LABEL maintainer="generic13 at gmail dot com"
LABEL version="0.1"
ENV REFRESHED_AT 2020_03_17
ENV GRANT_SUDO=yes
ENV JUPYTER_ENABLE_LAB=yes
USER root
WORKDIR /home/jovyan/work
RUN apt-get update && apt-get install -y \
    nodejs && rm -rf /var/lib/apt/lists/*
USER jovyan
COPY requirements.txt ./
#RUN pip install --upgrade pip; pip install -r requirements.txt
RUN python -m pip install --upgrade --force-reinstall pip; \
    pip install -r requirements.txt
RUN jupyter serverextension enable jupyterlab_sql --py --sys-prefix
RUN jupyter lab build
