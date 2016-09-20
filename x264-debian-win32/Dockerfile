FROM registry.videolan.org:5000/videolan-base-sid:latest

RUN apt-get update && apt-get -y install \
    gcc-mingw-w64-i686 g++-mingw-w64-i686 mingw-w64-tools make git yasm && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*
