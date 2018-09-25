FROM registry.videolan.org:5000/videolan-base-sid:20180419103824

RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends -y \
        git-core build-essential python3-pip python3-setuptools \
        python3-wheel nasm && \
    pip3 install meson ninja && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*
