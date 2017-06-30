FROM registry.videolan.org:5000/videolan-base-stretch:latest

ENV IMAGE_DATE=201612031725

RUN apt-get update && apt-get build-dep -y vlc && \
    apt-get install -y git-core libtool automake autoconf autopoint make \
    gettext pkg-config subversion cmake cvs zip bzip2 p7zip-full wget dos2unix \
    ragel yasm g++ protobuf-compiler m4 ant build-essential libtool-bin && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*
