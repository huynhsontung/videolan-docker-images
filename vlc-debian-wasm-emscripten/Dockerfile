FROM debian:bullseye-20210902-slim

ENV IMAGE_DATE=202109151132

ARG VIDEOLAN_UID=499
ARG EMSDK_VERSION=latest
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
     PROTOBUF_VERSION=3.1.0 && \
     PROTOBUF_SHA256=51ceea9957c875bdedeb1f64396b5b0f3864fe830eed6a2d9c066448373ea2d6 && \
     wget -q https://github.com/google/protobuf/releases/download/v$PROTOBUF_VERSION/protobuf-cpp-$PROTOBUF_VERSION.tar.gz && \
     echo $PROTOBUF_SHA256 protobuf-cpp-$PROTOBUF_VERSION.tar.gz | sha256sum -c && \
     tar xzfo protobuf-cpp-$PROTOBUF_VERSION.tar.gz && \
     cd protobuf-$PROTOBUF_VERSION && \
     ./configure --prefix=/opt/tools/ --disable-shared --enable-static && make -j$CORES && make install && \
     rm -rf /build/*

USER videolan

WORKDIR /home/videolan

RUN git clone --depth=1 https://github.com/emscripten-core/emsdk/ && \
    cd emsdk && ./emsdk install $EMSDK_VERSION && \
    ./emsdk activate $EMSDK_VERSION

ENV EMSCRIPTEN_SDK="/home/videolan/emsdk"
