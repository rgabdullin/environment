#!/bin/bash
set -e

git clone https://github.com/Syllo/nvtop.git /tmp/nvtop
cd /tmp/nvtop 
mkdir build
cd build 
echo $(pwd)
cmake .. 
make
make install
