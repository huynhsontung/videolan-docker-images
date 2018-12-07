FROM debian:sid-20181112-slim

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=201812071400

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the videolan user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG VIDEOLAN_UID=499

RUN addgroup --quiet --gid ${VIDEOLAN_UID} videolan && \
    adduser --quiet --uid ${VIDEOLAN_UID} --ingroup videolan videolan && \
    echo "videolan:videolan" | chpasswd && \
    apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends -y \
        lftp ca-certificates curl git-core build-essential python3-pip \
        python3-setuptools python3-wheel nasm clang \
        gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 \
        gcc-mingw-w64-i686 g++-mingw-w64-i686 mingw-w64-tools && \
    pip3 install meson ninja && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

COPY crossfiles/ /opt/crossfiles/

USER videolan
