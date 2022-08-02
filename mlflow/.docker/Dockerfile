FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# updating apt
RUN apt-get update --yes && \
    apt-get install --yes apt-utils \
                          python3-dev python3-pip python3-wheel \
                          && rm -rf /var/lib/apt/lists/*

RUN pip3 install -U pip wheel
RUN pip3 install mlflow

EXPOSE 5000
COPY .docker/entrypoint.sh /run/scripts/entrypoint.sh

ENTRYPOINT [ "/run/scripts/entrypoint.sh"]