FROM registry.videolan.org:5000/videolan-base-sid:latest

ENV IMAGE_DATE=201707021245

RUN apt-get update && apt-get build-dep -y vlc && \
    apt-get install -y git-core libtool automake autoconf autopoint make \
    gettext pkg-config subversion cmake cvs zip bzip2 p7zip-full wget \
    dos2unix ragel yasm g++ protobuf-compiler m4 ant build-essential \
    libtool-bin libavcodec-dev \
    libavformat-dev libavresample-dev libavutil-dev libpostproc-dev \
    libswscale-dev wayland-protocols qtbase5-private-dev libarchive-dev \
    libmicrodns-dev libmpg123-dev libnfs-dev curl libltdl-dev && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*
