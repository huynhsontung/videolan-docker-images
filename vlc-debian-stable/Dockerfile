FROM registry.videolan.org/videolan-base-buster:20190716161239

ENV IMAGE_DATE=201907162000

RUN apt-get update && apt-get build-dep -y vlc && \
    apt-get install -y git-core libtool automake autoconf autopoint make \
    gettext pkg-config subversion cmake cvs zip bzip2 p7zip-full wget dos2unix \
    ragel yasm g++ protobuf-compiler m4 ant build-essential libtool-bin \
    libavformat-dev libavresample-dev libavutil-dev libpostproc-dev \
    libswscale-dev wayland-protocols qtbase5-private-dev libarchive-dev \
    libmpg123-dev libnfs-dev libqt5svg5-dev flex bison curl \
    qtdeclarative5-dev qtquickcontrols2-5-dev nasm gcovr \
    libxkbcommon-x11-dev meson && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*
