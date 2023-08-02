FROM ubuntu:focal-20210416

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=202308021154
ENV LANG=en_US.UTF-8

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the videolan user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG VIDEOLAN_UID=499

ARG CORES=8

RUN addgroup --quiet --gid ${VIDEOLAN_UID} videolan && \
    adduser --quiet --uid ${VIDEOLAN_UID} --ingroup videolan videolan && \
    echo "videolan:videolan" | chpasswd

# Basic build tools
#echo "deb [http://ftp.fr.debian.org/debian/ bullseye main" > /etc/apt/sources.list && \
RUN echo "APT::Install-Recommends \"false\";\nAPT::Install-Suggests \"false\";" > /etc/apt/apt.conf.d/90local && \
    mkdir -p /usr/share/man/man1 && \
    apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y curl gnupg1 ca-certificates \
        git wget bzip2 file unzip libtool-bin pkg-config cmake build-essential \
        automake yasm gettext autopoint git-svn ninja-build ant \
        flex ragel bison zip dos2unix p7zip-full subversion gperf nasm \
        python python3 python3-venv python3-setuptools python3-mako locales meson help2man \
        vim nano openjdk-11-jdk qtchooser xcb-proto crossbuild-essential-armhf

RUN set -e && \
COMMENT="Pre-compiled Raspbian packages, so we don't rebuild everything" \
COMMENT="first install a main dependency, which doesn't work well with the others" \
    echo "deb [arch=amd64] http://archive.ubuntu.com/ubuntu/     focal          main multiverse restricted universe" >  /etc/apt/sources.list && \
    echo "deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ focal          main multiverse restricted universe" >> /etc/apt/sources.list && \
    echo "deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ focal-updates  main multiverse restricted universe" >> /etc/apt/sources.list && \
    echo "deb [arch=amd64] http://archive.ubuntu.com/ubuntu/     focal-updates  main multiverse restricted universe" >> /etc/apt/sources.list && \
    echo "deb [arch=amd64] http://security.ubuntu.com/ubuntu/    focal-security main multiverse restricted universe" >> /etc/apt/sources.list && \
    dpkg --add-architecture armhf && \
    apt-get update && apt-get -y install \
        libc6:armhf && \
COMMENT="Get the Raspberry Pi custom system headers/libraries" \
    apt-get -y install \
        libraspberrypi-dev:armhf \
        libc6:armhf libxcb-xkb-dev:armhf libasound2-dev:armhf \
        libfontconfig1-dev:armhf libmpg123-dev:armhf libfaad-dev:armhf \
        libxcb-shm0-dev:armhf libxcb-composite0-dev:armhf libxcb-xv0-dev:armhf libxcb-randr0-dev:armhf \
        libupnp-dev:armhf \
        nettle-dev:armhf libgnutls28-dev:armhf && \
# COMMENT="Most prebuilt libraries we use in contribs" \
#     apt-get -y install \
#         libxcb-xkb-dev:armhf libmpg123-dev:armhf  \
#         libogg0:armhf libvorbis0a:armhf \
#         libfaad-dev:armhf libasound2-dev:armhf libfontconfig1-dev:armhf \
#         libgmp-dev:armhf libgcrypt20-dev:armhf nettle-dev:armhf libarchive-dev:armhf \
#         libx264-dev:armhf libxml2-dev:armhf libchromaprint-dev:armhf libgcrypt20:armhf \
#         libaribb24-dev:armhf libass-dev:armhf libbluray-dev:armhf libcddb-dev:armhf libdav1d-dev:armhf libdca-dev:armhf libdvbpsi-dev:armhf \
#         libdvdnav-dev:armhf libdvdread-dev:armhf libflac-dev:armhf libfribidi-dev:armhf libgcrypt-dev:armhf libgme-dev:armhf libharfbuzz-dev:armhf \
#         libkate-dev:armhf libmatroska-dev:armhf \
#         libmicrodns-dev:armhf libmodplug-dev:armhf libmpcdec-dev:armhf libmysofa-dev:armhf libnfs-dev:armhf \
#         libogg-dev:armhf libopus-dev:armhf libpostproc-dev:armhf \
#         libsamplerate-dev:armhf libschroedinger-dev:armhf libshout-dev:armhf libsoxr-dev:armhf libspatialaudio-dev:armhf \
#         libspeex-dev:armhf libspeexdsp-dev:armhf libsqlite3-dev:armhf libsrtp2-dev:armhf libtheora-dev:armhf libtwolame-dev:armhf libupnp-dev:armhf \
#         libvorbis-dev:armhf libvpx-dev:armhf libx265-dev:armhf libzvbi-dev:armhf \
#         libgnutls28-dev:armhf libmad0-dev:armhf libsdl1.2-dev:armhf libmpeg2-4-dev:armhf \
#         libfluidsynth-dev:armhf libsdl-image1.2-dev:armhf libssh2-1-dev:armhf \
#         libxcb-shm0-dev:armhf libxcb-composite0-dev:armhf libxcb-xv0-dev:armhf libxcb-randr0-dev:armhf \
#         glslang-dev:armhf libplacebo-dev:armhf libaom-dev:armhf libvncserver-dev:armhf \
#         libavcodec-dev:armhf libavformat-dev:armhf libswscale-dev:armhf && \
COMMENT="Prebuilt Qt5 packages" \
    apt-get -y install \
        qtdeclarative5-dev:armhf \
        qtquickcontrols2-5-dev:armhf \
        qml-module-qtquick2:armhf \
        qml-module-qtquick-controls2:armhf \
        qml-module-qtquick-layouts:armhf \
        qml-module-qtquick-window2:armhf \
        qml-module-qtgraphicaleffects:armhf \
        qml-module-qtquick2:armhf \
        libqt5x11extras5-dev:armhf \
        libqt5svg5-dev:armhf

ENV PATH=/opt/tools/bin:$PATH

RUN set -e && \
COMMENT="Prebuild build tools" \
    mkdir /build && cd /build && \
    CMAKE_MAIN_VERSION=3.24 && CMAKE_VERSION=$CMAKE_MAIN_VERSION.2 && \
    CMAKE_SHA256=0d9020f06f3ddf17fb537dc228e1a56c927ee506b486f55fe2dc19f69bf0c8db && \
    wget -q https://www.cmake.org/files/v$CMAKE_MAIN_VERSION/cmake-$CMAKE_VERSION.tar.gz && \
    echo $CMAKE_SHA256 cmake-$CMAKE_VERSION.tar.gz | sha256sum -c && \
    tar xzf cmake-$CMAKE_VERSION.tar.gz && \
    cd cmake-$CMAKE_VERSION && ./configure --prefix=/opt/tools/ --parallel=$CORES --no-qt-gui -- \
        -DCMAKE_USE_OPENSSL:BOOL=OFF -DBUILD_TESTING:BOOL=OFF && make -j$CORES && make install && \
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
    rm -rf /build

# qtchooser doesn't have the arm-linux-gnueabihf target in the native package
RUN echo /usr/lib/qt5/bin >> /usr/share/qtchooser/qt5-arm-linux-gnueabihf.conf && \
    echo /usr/lib/arm-linux-gnueabihf >> /usr/share/qtchooser/qt5-arm-linux-gnueabihf.conf && \
COMMENT="Clean apt cache" \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
# RUN qtchooser -l

USER videolan
