FROM registry.videolan.org:5000/videolan-base-jessie:latest

RUN apt-get update && \
    apt-get install -y git make yasm gcc && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*
