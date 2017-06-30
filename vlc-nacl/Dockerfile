FROM registry.videolan.org:5000/videolan-base-stretch:latest

MAINTAINER Bastien Penavayre <bastienPenava@gmail.com>

ENV IMAGE_DATE=201706301131

ENV DEP_ROOT="/deps/"

RUN mkdir $DEP_ROOT && cd $DEP_ROOT && \
    dpkg --add-architecture i386 && \
    apt-get update && apt-get -y install \
    wget automake autoconf make gettext pkg-config python2.7 python-dev \
    curl sed cmake texinfo autoconf automake libtool libglib2.0-dev \
    libxml2 git cmake unzip libc6:i386 libstdc++6:i386 && \
    apt-get clean -y && rm -fr /var/lib/apt/lists/*

ADD 0001-Disable-arm-testing-for-zlib-on-x86-systems.patch /deps/

ENV PEPPER_VERSION="pepper_49"
ENV NACL_SDK_ROOT="$DEP_ROOT/nacl_sdk/$PEPPER_VERSION/"
ENV WEBPORTS_ROOT="$DEP_ROOT/webports/src/"

RUN  git config --global user.name "VideoLAN Buildbot" && \
     git config --global user.email buildbot@videolan.org  && \
     cd $DEP_ROOT && \
     wget -q https://storage.googleapis.com/nativeclient-mirror/nacl/nacl_sdk/nacl_sdk.zip &&\
     git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git && \
     unzip nacl_sdk.zip && cd nacl_sdk && \
     ./naclsdk install $PEPPER_VERSION && \
     cd $DEP_ROOT && mkdir webports && cd webports && \
     ../depot_tools/gclient config --unmanaged --name=src https://chromium.googlesource.com/webports.git && \
     ../depot_tools/gclient sync && \
     cd src && git checkout -b $PEPPER_VERSION origin/$PEPPER_VERSION && \
     git apply $DEP_ROOT/0001-Disable-arm-testing-for-zlib-on-x86-systems.patch && \
     ../../depot_tools/gclient sync --with_branch_heads && \
     ./bin/webports -t pnacl -a pnacl install libtheora libvorbis zlib ffmpeg libogg flac libpng x264 lame freetype fontconfig libxml2 libarchive mpg123 libmodplug faad2 libebml libmatroska
