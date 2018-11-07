FROM registry.videolan.org:5000/videolan-base-sid:20180419103824

ENV IMAGE_DATE=20181107204500

RUN apt-get update && apt-get build-dep -y vlc && \
    apt-get install -y git-core libtool automake autoconf autopoint make \
    ninja-build python3 \
    gettext pkg-config subversion cmake cvs zip bzip2 p7zip-full wget \
    dos2unix ragel yasm g++ protobuf-compiler m4 ant build-essential \
    libtool-bin libavcodec-dev \
    libavformat-dev libavresample-dev libavutil-dev libpostproc-dev \
    libswscale-dev wayland-protocols qtbase5-private-dev libarchive-dev \
    libmicrodns-dev libmpg123-dev libnfs-dev curl libltdl-dev libqt5svg5-dev \
    flex bison libxkbcommon-x11-dev libplacebo-dev meson && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    echo "IMAGE_DATE=20180419103824" >> /etc/environment
