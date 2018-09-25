FROM registry.videolan.org:5000/videolan-base-sid:20180419103824

ENV IMAGE_DATE=201809251718

RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends -y \
        git-core build-essential python3-pip python3-setuptools \
        python3-wheel nasm \
        gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 \
        gcc-mingw-w64-i686 g++-mingw-w64-i686 mingw-w64-tools && \
    pip3 install meson ninja && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

COPY crossfiles/ /opt/crossfiles/
