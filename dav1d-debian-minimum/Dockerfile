FROM debian:buster-20230202-slim

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=202204221700

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
    apt-get -y dist-upgrade && \
    apt-get install --no-install-suggests --no-install-recommends -y \
        ca-certificates curl git build-essential python3-pip \
        python3-setuptools python3-wheel nasm \
        doxygen graphviz ninja-build && \
    pip3 install --no-cache-dir meson==0.49 && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

USER videolan
