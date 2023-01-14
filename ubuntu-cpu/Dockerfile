FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# updating apt
RUN apt-get update --yes && \
    apt-get install --yes apt-utils \
                          build-essential gcc g++ \
                          python3-dev python3-pip python3-wheel \
                          htop tmux ninja-build \
                          git cmake make wget curl \
                          tmux htop supervisor \
                          libgl1 \
                          libglx0 \
                          libgl1-mesa-dev \
                          libgles2-mesa-dev \
                          && rm -rf /var/lib/apt/lists/*

# python packages
RUN pip3 install --no-cache -U pip wheel
RUN pip3 install --no-cache pylint
RUN pip3 install --no-cache ipykernel notebook jupyter widgetsnbextension RISE

RUN pip3 install --no-cache ipykernel notebook jupyter widgetsnbextension RISE k3d
RUN jupyter nbextension enable --py widgetsnbextension
RUN jupyter nbextension install --py --sys-prefix k3d
RUN jupyter nbextension enable --py --sys-prefix k3d

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache -r /tmp/requirements.txt

COPY search_fix.patch /tmp/search_fix.patch
RUN patch /usr/local/lib/python3.8/dist-packages/sklearn/model_selection/_search.py /tmp/search_fix.patch

COPY scripts/ /run/scripts
COPY scripts/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /workspace
ENTRYPOINT [ "/bin/bash" ]
