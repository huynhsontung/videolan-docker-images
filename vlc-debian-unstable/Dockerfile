FROM debian:sid-20210721-slim

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=202108031328

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the videolan user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG VIDEOLAN_UID=499

ARG CORES=8

ENV PATH=/opt/tools/bin:$PATH

RUN set -x && \
    addgroup --quiet --gid ${VIDEOLAN_UID} videolan && \
    adduser --quiet --uid ${VIDEOLAN_UID} --ingroup videolan videolan && \
    echo "videolan:videolan" | chpasswd && \
    mkdir -p /usr/share/man/man1 && \
    echo "deb http://ftp.fr.debian.org/debian/ sid main" > /etc/apt/sources.list && \
    echo "deb-src http://ftp.fr.debian.org/debian/ sid main" >> /etc/apt/sources.list && \
    apt-get update && apt-get upgrade -q -y && \
    apt-get install -y --no-install-suggests --no-install-recommends \
    openjdk-11-jdk lftp ca-certificates git-core libtool automake autoconf \
    autopoint make ninja-build python3 gettext pkg-config subversion \
    cvs zip bzip2 p7zip-full wget dos2unix ragel yasm g++ \
    m4 ant build-essential libtool-bin libavcodec-dev gdb \
    libavformat-dev libavresample-dev libavutil-dev libpostproc-dev \
    libswscale-dev wayland-protocols qtbase5-private-dev libarchive-dev \
    libmpg123-dev libnfs-dev curl libltdl-dev libqt5svg5-dev \
    qtdeclarative5-dev qtquickcontrols2-5-dev qml-module-qtquick-controls2 \
    qml-module-qtquick-layouts qml-module-qtquick-templates2 \
    qml-module-qtgraphicaleffects flex bison libxkbcommon-x11-dev libplacebo-dev \
    meson doxygen graphviz libsqlite3-dev rapidjson-dev nasm cmake libxcb-damage0-dev && \
    apt-get build-dep --no-install-suggests --no-install-recommends -y vlc && \
    apt-get remove -y libprotobuf-dev protobuf-compiler && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    mkdir /build && cd /build && \
    PROTOBUF_VERSION=3.1.0 && \
    PROTOBUF_SHA256=51ceea9957c875bdedeb1f64396b5b0f3864fe830eed6a2d9c066448373ea2d6 && \
    wget -q https://github.com/google/protobuf/releases/download/v$PROTOBUF_VERSION/protobuf-cpp-$PROTOBUF_VERSION.tar.gz && \
    echo $PROTOBUF_SHA256 protobuf-cpp-$PROTOBUF_VERSION.tar.gz | sha256sum -c && \
    tar xzfo protobuf-cpp-$PROTOBUF_VERSION.tar.gz && \
    cd protobuf-$PROTOBUF_VERSION && \
    ./configure --prefix=/opt/tools/ --disable-shared --enable-static && make -j$CORES && make install && \
    rm -rf /build/*


USER videolan
