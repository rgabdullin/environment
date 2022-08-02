FROM nvidia/cuda:11.6.1-cudnn8-devel-ubuntu20.04

# environment
ENV DEBIAN_FRONTEND=noninteractive

# updating apt
RUN apt-get update --yes
RUN apt-get install --yes apt-utils \
                          build-essential gcc g++ \
                          python3-dev python3-pip python3-wheel \
                          htop tmux ninja-build \
                          git cmake make curl wget nano wget \
                          libncurses5-dev libncursesw5-dev \
                          ffmpeg libsm6 libxext6 \
                          supervisor \
                          libglvnd0 \
                          libgl1 \
                          libglx0 \
                          libegl1 \
                          libgles2 \
                          libglvnd-dev \
                          libgl1-mesa-dev \
                          libegl1-mesa-dev \
                          libgles2-mesa-dev \
                          xvfb \
                          && rm -rf /var/lib/apt/lists/*

# nvtop
COPY scripts/build_nvtop.sh /tmp/build_nvtop.sh
RUN chmod +x /tmp/build_nvtop.sh && /tmp/build_nvtop.sh

# vscode server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# for GLEW
ENV LD_LIBRARY_PATH /usr/lib64:$LD_LIBRARY_PATH
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics
ENV PYOPENGL_PLATFORM=egl

COPY files/10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json

# installing python packages
RUN pip install --no-cache -U pip wheel
RUN pip install --no-cache -U setuptools

# vscode
RUN pip3 install --no-cache pylint

# jupyter notebook
RUN pip3 install --no-cache ipykernel notebook jupyter widgetsnbextension RISE k3d
RUN jupyter nbextension enable --py widgetsnbextension && \
    jupyter nbextension install --py --sys-prefix k3d && \
    jupyter nbextension enable --py --sys-prefix k3d

# cupy
RUN pip3 install --no-cache cupy-cuda116
# RUN python3 -m cupyx.tools.install_library --cuda 11.6 --library cutensor
# RUN python3 -m cupyx.tools.install_library --cuda 11.6 --library cudnn
# RUN python3 -m cupyx.tools.install_library --cuda 11.6 --library nccl

# nvidia smi
RUN nvidia-smi

# pytorch
RUN pip3 install --no-cache torch torchvision torchaudio torchtext --extra-index-url https://download.pytorch.org/whl/cu116
RUN pip3 install --no-cache albumentations pytorch_lightning torchmetrics torchsummary tensorboard

# pytorch3d
RUN pip3 install --no-cache "git+https://github.com/facebookresearch/pytorch3d.git@stable"

# installing libraries
COPY core_requirements.txt /tmp/core_requirements.txt
RUN pip install --no-cache -r /tmp/core_requirements.txt

COPY ml_requirements.txt /tmp/ml_requirements.txt
RUN pip install --no-cache -r /tmp/ml_requirements.txt

# sklearn patch
COPY files/search_fix.patch /tmp/search_fix.patch
RUN patch /usr/local/lib/python3.8/dist-packages/sklearn/model_selection/_search.py /tmp/search_fix.patch

# entrypoint
COPY scripts/ /run/scripts
COPY files/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /workspace
CMD [ "/bin/bash" ]
