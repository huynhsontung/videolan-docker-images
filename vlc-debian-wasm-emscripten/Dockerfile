FROM debian:bullseye-20210902-slim

ENV IMAGE_DATE=202111041738

ARG VIDEOLAN_UID=499
ARG EMSDK_VERSION=3.1.9
ARG CORES=8

COPY patches /patches

ENV PATH=/opt/tools/bin:$PATH

RUN  set -x && \
     apt-get update && \
     apt-get install -y git-core libtool automake autoconf autopoint make \
     gettext pkg-config subversion cmake cvs zip bzip2 p7zip-full wget dos2unix \
     ragel yasm g++ m4 ant build-essential libtool-bin gperf \
     flex bison curl nasm meson python3 && \
     apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
     addgroup --quiet --gid ${VIDEOLAN_UID} videolan && \
     adduser --quiet --uid ${VIDEOLAN_UID} --ingroup videolan videolan && \
     echo "videolan:videolan" | chpasswd && \
     cd /usr/share/misc && \
     patch -l < /patches/emscripten-automake.patch && \
     mkdir /build && cd /build && \
     PROTOBUF_VERSION=3.4.1 && \
     PROTOBUF_SHA256=2bb34b4a8211a30d12ef29fd8660995023d119c99fbab2e5fe46f17528c9cc78 && \
     wget -q https://github.com/google/protobuf/releases/download/v$PROTOBUF_VERSION/protobuf-cpp-$PROTOBUF_VERSION.tar.gz && \
     echo $PROTOBUF_SHA256 protobuf-cpp-$PROTOBUF_VERSION.tar.gz | sha256sum -c && \
     tar xzfo protobuf-cpp-$PROTOBUF_VERSION.tar.gz && \
     cd protobuf-$PROTOBUF_VERSION && \
# force include <algorithm> \
     sed -i.orig 's,#ifdef _MSC_VER,#if 1,' "src/google/protobuf/repeated_field.h" && \
     cmake  -S cmake -B cbuild -DBUILD_SHARED_LIBS=OFF -Dprotobuf_BUILD_TESTS=OFF -Dprotobuf_BUILD_EXAMPLES=OFF && \
     cmake --build cbuild --parallel $CORES && cmake --install cbuild --prefix /opt/tools && \
     rm -rf /build/*

USER videolan

WORKDIR /home/videolan

RUN git clone --depth=1 https://github.com/emscripten-core/emsdk/ && \
    cd emsdk && ./emsdk install $EMSDK_VERSION && \
    ./emsdk activate $EMSDK_VERSION

RUN git config --global user.name "VLC.js" && \
    git config --global user.email buildbot@videolan.org

ENV EMSCRIPTEN_SDK="/home/videolan/emsdk"
