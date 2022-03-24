FROM ubuntu:bionic-20220315

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=202203241700

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
        lftp ca-certificates curl git build-essential \
        procps snapcraft ninja-build python3-pip python3-setuptools \
        python3-wheel meson && \
    echo "deb http://archive.ubuntu.com/ubuntu/ focal main restricted" >> /etc/apt/sources.list.d/focal.list && \
    echo "deb http://archive.ubuntu.com/ubuntu/ focal universe" >> /etc/apt/sources.list.d/focal.list && \
    apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends -y \
        nasm && \
    pip3 install meson && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

USER videolan
