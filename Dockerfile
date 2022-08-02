FROM nvidia/cuda:11.6.2-cudnn8-devel-ubuntu20.04

# environment
ENV DEBIAN_FRONTEND=noninteractive

# updating apt
RUN apt-get update --yes
RUN apt-get install --yes apt-utils
RUN apt-get install --yes build-essential gcc g++ 
RUN apt-get install --yes python3-dev python3-pip python3-wheel
RUN apt-get install --yes htop tmux ninja-build
RUN apt-get install --yes git cmake make wget curl nano

# EGL
RUN apt-get install --yes libglvnd0 \
                          libgl1 \
                          libglx0 \
                          libegl1 \
                          libgles2 \
                          libglvnd-dev \
                          libgl1-mesa-dev \
                          libegl1-mesa-dev \
                          libgles2-mesa-dev \
                          xvfb

# for GLEW
ENV LD_LIBRARY_PATH /usr/lib64:$LD_LIBRARY_PATH
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics
ENV PYOPENGL_PLATFORM=egl
COPY 10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json

# nvtop
RUN apt-get install --yes libncurses5-dev libncursesw5-dev
ADD build_nvtop.sh /tmp/build_nvtop.sh
RUN chmod +x /tmp/build_nvtop.sh && /tmp/build_nvtop.sh

# for opencv
RUN apt-get install --yes ffmpeg libsm6 libxext6

# installing python packages
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -U setuptools
RUN pip install --no-cache-dir -U cmake

# vscode
RUN pip3 install --no-cache-dir pylint

# cupy
RUN pip3 install --no-cache-dir cupy-cuda116
RUN python3 -m cupyx.tools.install_library --cuda 11.6 --library cutensor
RUN python3 -m cupyx.tools.install_library --cuda 11.6 --library nccl

# opencv
RUN pip3 install --no-cache-dir opencv-python

# jupyter notebook
RUN pip3 install --no-cache-dir ipykernel notebook jupyter widgetsnbextension RISE
RUN jupyter notebook --generate-config
ADD jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.password = '`python3 -c "from notebook.auth import passwd; print(passwd('Ruslix96'))"`'" \
    >> /root/.jupyter/jupyter_notebook_config.py

# pytorch
RUN pip3 install --no-cache-dir tensorboard
RUN pip3 install --no-cache-dir "torch<1.11" \ 
                                torchvision \
                                torchaudio \
                                torchtext -f https://download.pytorch.org/whl/cu113/torch_stable.html
RUN pip3 install --no-cache-dir albumentations torchsummary pytorch_lightning torchmetrics torchsummary


# pytorch3d
RUN pip3 install --no-cache-dir "git+https://github.com/facebookresearch/pytorch3d.git@stable"

# fix sklearn bug
# ADD search_fix.py /usr/local/lib/python3.8/dist-packages/sklearn/model_selection/_search.py

# installing libraries
ADD core_requirements.txt /tmp/core_requirements.txt
RUN pip install --no-cache-dir -r /tmp/core_requirements.txt

ADD ml_requirements.txt /tmp/ml_requirements.txt
RUN pip install --no-cache-dir -r /tmp/ml_requirements.txt

ADD dl_requirements.txt /tmp/dl_requirements.txt
RUN pip install --no-cache-dir -r /tmp/dl_requirements.txt

# k3d
RUN jupyter nbextension install --py --sys-prefix k3d
RUN jupyter nbextension enable --py --sys-prefix k3d

RUN mkdir /workspace
WORKDIR /workspace
CMD [ "jupyter", "notebook", "--allow-root" ]
