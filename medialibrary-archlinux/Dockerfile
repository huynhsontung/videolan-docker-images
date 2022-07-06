FROM archlinux:base-devel-20220703.0.65849

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=202207061404

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the videolan user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG VIDEOLAN_UID=499

ARG CORES=8

RUN set -x && \
    groupadd --gid ${VIDEOLAN_UID} videolan && \
    useradd -m --uid ${VIDEOLAN_UID} -g videolan videolan && \
    echo "videolan:videolan" | chpasswd && \
    pacman -Suy --noconfirm \
        git meson ninja xxhash && \
    pacman -Scc --noconfirm

USER videolan
