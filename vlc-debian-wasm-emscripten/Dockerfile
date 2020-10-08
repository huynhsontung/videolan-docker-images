FROM debian:bullseye-slim

ENV IMAGE_DATE=20201009100000

ARG VIDEOLAN_UID=499

COPY patches /patches

RUN  set -x && \
     mkdir  /usr/share/man/man1/ && \ 
     apt-get update && \
     apt-get install -y git-core libtool automake autoconf autopoint make \
     gettext pkg-config subversion cmake cvs zip bzip2 p7zip-full wget dos2unix \
     ragel yasm g++ protobuf-compiler m4 ant build-essential libtool-bin \
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
    cd emsdk && ./emsdk install latest && \
    ./emsdk activate latest && \
    cd upstream/emscripten && \
    patch -p1 < /patches/emscripten-nativefs.patch

ENV EMSCRIPTEN_SDK="/home/videolan/emsdk"