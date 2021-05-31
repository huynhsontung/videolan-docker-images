FROM debian:bullseye-20210511-slim

ENV IMAGE_DATE=20210601100000

ARG VIDEOLAN_UID=499
ARG EMSDK_VERSION=latest

COPY patches /patches

RUN  set -x && \
     mkdir  /usr/share/man/man1/ && \ 
     apt-get update && \
     apt-get install -y git-core libtool automake autoconf autopoint make \
     gettext pkg-config subversion cmake cvs zip bzip2 p7zip-full wget dos2unix \
     ragel yasm g++ protobuf-compiler m4 ant build-essential libtool-bin gperf \
     flex bison curl nasm meson python3 && \
     apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
     addgroup --quiet --gid ${VIDEOLAN_UID} videolan && \
     adduser --quiet --uid ${VIDEOLAN_UID} --ingroup videolan videolan && \
     echo "videolan:videolan" | chpasswd && \
     cd /usr/share/misc && \
     patch -l < /patches/emscripten-automake.patch

USER videolan

WORKDIR /home/videolan

RUN git clone --depth=1 https://github.com/emscripten-core/emsdk/ && \
    cd emsdk && ./emsdk install $EMSDK_VERSION && \
    ./emsdk activate $EMSDK_VERSION

ENV EMSCRIPTEN_SDK="/home/videolan/emsdk"
