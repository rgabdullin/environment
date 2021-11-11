#!/bin/bash
set -e

mkdir /rapids
cd /rapids

export CUDF_HOME=/rapids/cudf
git clone https://github.com/rapidsai/cudf.git $CUDF_HOME
cd $CUDF_HOME
git submodule update --init --remote --recursive

apt install --yes libssl-dev

export INSTALL_PREFIX=/usr/local/lib/python3.8/dist-packages
./build.sh