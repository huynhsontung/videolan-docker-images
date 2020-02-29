FROM debian:sid-20200224-slim

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=202002292010

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the videolan user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG VIDEOLAN_UID=499

RUN set -x && \
    addgroup --quiet --gid ${VIDEOLAN_UID} videolan && \
    adduser --quiet --uid ${VIDEOLAN_UID} --ingroup videolan videolan && \
    echo "videolan:videolan" | chpasswd && \
    mkdir -p /usr/share/man/man1 && \
    echo "deb http://ftp.fr.debian.org/debian/ sid main" > /etc/apt/sources.list && \
    echo "deb-src http://ftp.fr.debian.org/debian/ sid main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends \
    openjdk-11-jdk lftp ca-certificates git-core libtool automake autoconf \
    autopoint make  ninja-build python3 gettext pkg-config subversion cmake \
    cvs zip bzip2 p7zip-full wget dos2unix ragel yasm g++ g++-7 \
    m4 ant build-essential libtool-bin libavcodec-dev gdb \
    libavformat-dev libavresample-dev libavutil-dev libpostproc-dev \
    libswscale-dev wayland-protocols qtbase5-private-dev libarchive-dev \
    libmpg123-dev libnfs-dev curl libltdl-dev libqt5svg5-dev \
    qtdeclarative5-dev qtquickcontrols2-5-dev qml-module-qtquick-controls2 \
    qml-module-qtquick-layouts qml-module-qtquick-templates2 \
    qml-module-qtgraphicaleffects flex bison libxkbcommon-x11-dev libplacebo-dev \
    meson doxygen graphviz libsqlite3-dev rapidjson-dev && \
    apt-get build-dep -y vlc && \
    apt-get remove libprotobuf-dev && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

USER videolan
