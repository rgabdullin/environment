FROM nvidia/cuda:11.4.2-cudnn8-devel-ubuntu20.04

# environment
ENV DEBIAN_FRONTEND=noninteractive

# updating apt
RUN apt-get update --yes
RUN apt-get install --yes apt-utils
RUN apt-get install --yes build-essential gcc g++ 
RUN apt-get install --yes python3-dev python3-pip python3-wheel
RUN apt-get install --yes htop tmux ninja-build
RUN apt-get install --yes git cmake make

# nvtop
RUN apt-get install --yes libncurses5-dev libncursesw5-dev
ADD build_nvtop.sh /tmp/build_nvtop.sh
RUN chmod +x /tmp/build_nvtop.sh && /tmp/build_nvtop.sh

# installing python packages
RUN pip install -U pip
RUN pip install -U setuptools
RUN pip install -U cmake

# tensorflow
RUN pip3 install tensorflow==2.6.0 keras==2.6.0

# cupy
RUN pip3 install cupy-cuda114==9.5.0
RUN python3 -m cupyx.tools.install_library --cuda 11.4 --library cutensor
RUN python3 -m cupyx.tools.install_library --cuda 11.4 --library nccl

# pytorch
ENV NVIDIA_VISIBLE_DEVICES=all
RUN pip3 install torch==1.10.0+cu113 \ 
                 torchvision==0.11.1+cu113 \
                 torchaudio==0.10.0+cu113 \
                 torchtext==0.11.0 \
                 -f https://download.pytorch.org/whl/cu113/torch_stable.html
RUN pip3 install albumentations==1.1.0
RUN pip3 install torchsummary==1.5.1
RUN pip3 install pytorch_lightning==1.5.1 torchmetrics==0.6.0 torchsummary==1.5.1

# opencv
RUN apt-get install --yes ffmpeg libsm6 libxext6
RUN pip3 install opencv-python==4.5.4.58

# jax
RUN pip3 install "jax[cuda]==0.2.24" -f https://storage.googleapis.com/jax-releases/jax_releases.html
RUN pip3 install "jaxlib[cuda]==0.1.73" -f https://storage.googleapis.com/jax-releases/jax_releases.html
RUN pip3 install rlax==0.0.4
RUN pip3 install optax==0.0.9

# jupyter notebook
RUN pip3 install ipykernel==6.4.2 notebook==6.4.5 jupyter==1.0.0 widgetsnbextension==3.5.2 RISE==5.7.1
RUN jupyter notebook --generate-config
ADD jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.password = '`python3 -c "from notebook.auth import passwd; print(passwd('Ruslix96'))"`'" \
    >> /root/.jupyter/jupyter_notebook_config.py

# installing libraries
ADD core_requirements.txt /tmp/core_requirements.txt
RUN pip install -r /tmp/core_requirements.txt

ADD ml_requirements.txt /tmp/ml_requirements.txt
RUN pip install -r /tmp/ml_requirements.txt

ADD dl_requirements.txt /tmp/dl_requirements.txt
RUN pip install -r /tmp/dl_requirements.txt

# k3d
RUN jupyter nbextension install --py --sys-prefix k3d
RUN jupyter nbextension enable --py --sys-prefix k3d

# fix sklearn bug
ADD search_fix.py /usr/local/lib/python3.8/dist-packages/sklearn/model_selection/_search.py

RUN mkdir /workspace
WORKDIR /workspace
CMD [ "jupyter", "notebook", "--allow-root" ]
