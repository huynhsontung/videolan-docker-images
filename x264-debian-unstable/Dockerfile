FROM registry.videolan.org:5000/videolan-base-stretch:20180419104422

ENV IMAGE_DATE=201809251403

RUN apt-get update && apt-get -y install \
    gcc make git \
    gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 \
    gcc-mingw-w64-i686 g++-mingw-w64-i686 mingw-w64-tools \
    libavformat-dev libswscale-dev curl && \
    echo "deb http://deb.debian.org/debian unstable main" > /etc/apt/sources.list.d/unst.list && \
    apt-get update && apt-get -y -t unstable install nasm && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*
