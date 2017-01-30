FROM registry.videolan.org:5000/videolan-base-sid:latest

ENV IMAGE_DATE=201701301134

RUN apt-get update && apt-get -y install \
    gcc make git yasm \
    gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 \
    gcc-mingw-w64-i686 g++-mingw-w64-i686 mingw-w64-tools && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*
