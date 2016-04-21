FROM videolan-base-jessie:latest

RUN apt-get update && apt-get build-dep -y vlc && \
    apt-get install -y git-core && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*
