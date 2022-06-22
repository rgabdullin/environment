FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# updating apt
RUN apt-get update --yes
RUN apt-get install --yes apt-utils
RUN apt-get install --yes build-essential gcc g++ 
RUN apt-get install --yes python3-dev python3-pip python3-wheel
RUN apt-get install --yes htop tmux ninja-build
RUN apt-get install --yes git cmake make wget curl

RUN apt-get install --yes tmux htop supervisor

# python packages
RUN pip3 install -U pip wheel
RUN pip3 install pylint
RUN pip3 install ipykernel==6.4.2 notebook==6.4.5 jupyter==1.0.0 widgetsnbextension==3.5.2 RISE==5.7.1

COPY scripts/ /run/scripts
COPY scripts/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /workspace
ENTRYPOINT [ "/bin/bash" ]
