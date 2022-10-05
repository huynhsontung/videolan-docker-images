FROM debian:sid-20220125-slim

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=202201261339

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
    echo "deb http://ftp.debian.org/debian/ sid main" > /etc/apt/sources.list && \
    echo "deb-src http://ftp.debian.org/debian/ sid main" >> /etc/apt/sources.list && \
    apt-get update && apt-get upgrade -q -y && \
    apt-get install -y --no-install-suggests --no-install-recommends \
    openjdk-11-jdk lftp ca-certificates git-core libtool automake autoconf \
    autopoint make ninja-build python3 gettext pkg-config subversion \
    cvs zip bzip2 p7zip-full wget dos2unix ragel yasm g++ \
    m4 ant build-essential libtool-bin libavcodec-dev gdb \
    libavformat-dev libswresample-dev libavutil-dev libpostproc-dev \
    libswscale-dev wayland-protocols qtbase5-private-dev libarchive-dev \
    libmpg123-dev libnfs-dev curl libltdl-dev libqt5svg5-dev \
    qtdeclarative5-dev qtquickcontrols2-5-dev qml-module-qtquick-controls2 \
    qml-module-qtquick-layouts qml-module-qtquick-templates2 \
    qml-module-qtgraphicaleffects flex bison libxkbcommon-x11-dev libplacebo-dev \
    meson doxygen graphviz libsqlite3-dev rapidjson-dev nasm cmake libxcb-damage0-dev \
    clang libc++-dev libc++abi-dev llvm-13 gperf && \
    apt-get build-dep --no-install-suggests --no-install-recommends -y vlc && \
    apt-get remove -y libprotobuf-dev protobuf-compiler && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    mkdir /build && cd /build && \
    PROTOBUF_VERSION=3.4.1 && \
    PROTOBUF_SHA256=2bb34b4a8211a30d12ef29fd8660995023d119c99fbab2e5fe46f17528c9cc78 && \
    wget -q https://github.com/google/protobuf/releases/download/v$PROTOBUF_VERSION/protobuf-cpp-$PROTOBUF_VERSION.tar.gz && \
    echo $PROTOBUF_SHA256 protobuf-cpp-$PROTOBUF_VERSION.tar.gz | sha256sum -c && \
    tar xzfo protobuf-cpp-$PROTOBUF_VERSION.tar.gz && \
    cd protobuf-$PROTOBUF_VERSION && \
# force include <algorithm> \
    sed -i.orig 's,#ifdef _MSC_VER,#if 1,' "src/google/protobuf/repeated_field.h" && \
    cmake  -S cmake -B build -DBUILD_SHARED_LIBS=OFF -Dprotobuf_BUILD_TESTS=OFF -Dprotobuf_BUILD_EXAMPLES=OFF && \
    cmake --build build --parallel $CORES && cmake --install build --prefix /opt/tools && \
    rm -rf /build/*


USER videolan
