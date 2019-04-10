FROM registry.videolan.org/videolan-base-sid:20190408171718

ENV IMAGE_DATE=201904101518

RUN apt-get update && apt-get build-dep -y vlc && \
    apt-get install -y git-core libtool automake autoconf autopoint make \
    ninja-build python3 \
    gettext pkg-config subversion cmake cvs zip bzip2 p7zip-full wget \
    dos2unix ragel yasm g++ g++-7 protobuf-compiler m4 ant build-essential \
    libtool-bin libavcodec-dev gdb \
    libavformat-dev libavresample-dev libavutil-dev libpostproc-dev \
    libswscale-dev wayland-protocols qtbase5-private-dev libarchive-dev \
    libmicrodns-dev libmpg123-dev libnfs-dev curl libltdl-dev libqt5svg5-dev \
    qtdeclarative5-dev qtquickcontrols2-5-dev qml-module-qtquick-controls2 \
    qml-module-qtquick-layouts qml-module-qtquick-templates2 \
    qml-module-qtgraphicaleffects \
    flex bison libxkbcommon-x11-dev libplacebo-dev meson && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    echo "IMAGE_DATE=20180419103824" >> /etc/environment
