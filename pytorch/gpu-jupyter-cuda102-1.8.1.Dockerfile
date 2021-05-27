FROM nvidia/cuda:10.2-cudnn7-runtime-ubuntu18.04 as base

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        unzip


# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip

RUN python3 -m pip --no-cache-dir install --upgrade \
    "pip<20.3" \
    setuptools

RUN ln -s $(which python3) /usr/local/bin/python

RUN python3 -m pip install --no-cache-dir torch==1.8.1

RUN python3 -m pip install --no-cache-dir jupyter matplotlib
# Pin ipykernel and nbformat; see https://github.com/ipython/ipykernel/issues/422
RUN python3 -m pip install --no-cache-dir jupyter_http_over_ws ipykernel==5.1.1 nbformat==4.4.0
RUN jupyter serverextension enable --py jupyter_http_over_ws

RUN mkdir -p /home/jovyan && chmod -R a+rwx /home/jovyan
RUN mkdir /.local && chmod a+rwx /.local
RUN apt-get update && apt-get install -y --no-install-recommends wget git
RUN apt-get autoremove -y

WORKDIR /home/jovyan
EXPOSE 8888


RUN python3 -m ipykernel.kernelspec

ENV NB_PREFIX /

CMD ["bash", "-c", "source /etc/bash.bashrc && jupyter notebook --notebook-dir=/home/jovyan --ip 0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}"]
