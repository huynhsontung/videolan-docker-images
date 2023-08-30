FROM debian:sid-20221114-slim

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=202201261339

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the videolan user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG VIDEOLAN_UID=499

ARG CORES=8

ENV PATH=/opt/tools/bin:$PATH

RUN set -x && \
    mkdir -p /usr/share/man/man1 && \
    echo "deb http://ftp.debian.org/debian/ sid main" > /etc/apt/sources.list && \
    echo "deb-src http://ftp.debian.org/debian/ sid main" >> /etc/apt/sources.list && \
    apt-get update && apt-get upgrade -q -y && \
    apt-get install -y --no-install-suggests --no-install-recommends \
    openjdk-11-jdk lftp ca-certificates git-core libtool automake autoconf \
    autopoint make ninja-build python3 python3-venv gettext pkg-config subversion \
    cvs zip bzip2 p7zip-full wget dos2unix ragel yasm g++ \
    m4 ant build-essential libtool-bin libavcodec-dev gdb gcovr \
    libavformat-dev libswresample-dev libavutil-dev libpostproc-dev \
    libswscale-dev wayland-protocols qtbase5-private-dev libarchive-dev \
    libmpg123-dev libnfs-dev curl libltdl-dev freerdp2-dev libqt5svg5-dev \
    qtdeclarative5-dev qtquickcontrols2-5-dev qml-module-qtquick-controls2 \
    qml-module-qtquick-layouts qml-module-qtquick-templates2 qml-module-qttest \
    qml-module-qtgraphicaleffects flex bison libxkbcommon-x11-dev libx11-xcb-dev libplacebo-dev \
    meson doxygen graphviz libsqlite3-dev rapidjson-dev nasm cmake libxcb-damage0-dev \
    libprotobuf-dev protobuf-compiler \
    clang llvm-14 gperf libgstreamer-plugins-base1.0-dev \
    glslang-dev libfaad2 libfaad-dev libgmp-dev libmpcdec-dev libvpx-dev \
    libopencv-dev libgme-dev libaom-dev librav1e-dev libmfx-dev libebur128-dev librist-dev && \
    apt-get build-dep --no-install-suggests --no-install-recommends -y vlc && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    addgroup --quiet --gid ${VIDEOLAN_UID} videolan && \
    adduser --quiet --uid ${VIDEOLAN_UID} --ingroup videolan videolan && \
    echo "videolan:videolan" | chpasswd


USER videolan
