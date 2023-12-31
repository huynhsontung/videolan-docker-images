FROM debian:sid-20231030-slim

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=202311092200

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the videolan user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG VIDEOLAN_UID=499

RUN groupadd --gid ${VIDEOLAN_UID} videolan && \
    useradd --uid ${VIDEOLAN_UID} --gid videolan --create-home --shell /bin/bash videolan && \
    echo "videolan:videolan" | chpasswd && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends -y \
      lftp gcc make git curl nasm wine wine32 wine64 procps \
      ca-certificates libc-dev bzip2 \
      gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 \
      gcc-mingw-w64-i686 g++-mingw-w64-i686 mingw-w64-tools \
      gcc-aarch64-linux-gnu g++-aarch64-linux-gnu libc6-dev-arm64-cross \
      qemu-user && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

USER videolan

COPY scripts/wait_process.sh /opt/wine/
RUN wine wineboot --init && \
    /opt/wine/wait_process.sh wineserver
