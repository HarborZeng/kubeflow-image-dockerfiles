ARG BASE_IMAGE=gcr.io/kubeflow-images-public/tensorflow-2.1.0-notebook-gpu:1.0.0

FROM $BASE_IMAGE

RUN set -ex; \
    apt-get update; \
    apt-get install -yq --no-install-recommends htop rsync

ENV GRANT_SUDO yes
USER root

RUN echo "jovyan ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook

#ENTRYPOINT ["tini", "--"]
#CMD ["sh","-c", "jupyter notebook --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}"]
