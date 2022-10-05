FROM ubuntu:focal-20210416

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=202208100939
ENV LANG=en_US.UTF-8
ENV PATH="/snap/bin:/opt/protobuf/bin:$PATH:/usr/sbin"
ENV SNAP="/snap/snapcraft/current"
ENV SNAP_NAME="snapcraft"
ENV SNAP_ARCH="amd64"

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the videolan user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG VIDEOLAN_UID=499

RUN set -x && \
    export DEBIAN_FRONTEND=noninteractive && \
    addgroup --quiet --gid ${VIDEOLAN_UID} videolan && \
    adduser --quiet --uid ${VIDEOLAN_UID} --ingroup videolan videolan && \
    echo "videolan:videolan" | chpasswd && \
    apt-get update && apt-get install -y --no-install-suggests --no-install-recommends \
      gnupg1 && \
    echo "deb http://archive.neon.kde.org/user focal main" >> /etc/apt/sources.list.d/neon.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E6D4736255751E5D && \
    apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends \
      ant autoconf automake autopoint bison cmake flex g++ gettext \
      git git-core libasound2-dev libavahi-client-dev libcdio-dev libdbus-1-dev \
      libdirectfb-dev libegl1-mesa-dev libfreetype6-dev libfribidi-dev \
      libgles2-mesa-dev libgnutls28-dev libgtk2.0-dev libidn11-dev libjack-dev \
      liblircclient-dev libltdl-dev liblua5.2-dev libmtp-dev libncursesw5-dev \
      libpng-dev libpulse-dev libqt5svg5-dev libqt5x11extras5-dev librsvg2-dev \
      libsecret-1-dev libtool libtool-bin libudev-dev libupnp-dev libv4l-dev \
      libva-dev libvdpau-dev libx11-dev libxcb-composite0-dev libxcb-keysyms1-dev \
      libxcb-randr0-dev libxcb-shm0-dev libxcb-xfixes0-dev libxcb-xv0-dev libxcb1-dev \
      libxext-dev libxi-dev libxinerama-dev libxml2-dev libxpm-dev libzvbi-dev \
      locales lua5.2 make pkg-config p7zip-full wget qtbase5-dev qtbase5-private-dev ragel \
      vim xz-utils yasm zlib1g-dev libxkbcommon-x11-dev meson \
      curl build-essential python3-pip python3-setuptools python3-mako python3-wheel \
      nasm clang libvulkan-dev qtdeclarative5-dev qtquickcontrols2-5-dev \
      qml-module-qtquick-controls2 qml-module-qtquick-layouts qml-module-qtquick-templates2 \
      qml-module-qtgraphicaleffects gnupg1 ca-certificates lftp openjdk-11-jdk \
      wayland-protocols qtwayland5 libva-wayland2 \
      curl jq squashfs-tools snapd libgcrypt20-dev libsystemd-dev libxcb-damage0-dev gperf \
      && \
    pip3 install meson ninja && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8 && \
    echo "export PATH=\$PATH:/usr/sbin:/snap/bin" >> /etc/profile.d/vlc_env.sh && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && \
# apparently this dance is now needed to install snapcraft inside docker, and you cant just use .debs \
# see https://github.com/snapcore/snapcraft/blob/master/docker/stable.Dockerfile \
    curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/core20' | jq '.download_url' -r) --output core20.snap && \
    mkdir -p /snap/core20 && \
    unsquashfs -d /snap/core20/current core20.snap && \
    rm -f core20.snap && \
    curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/core18' | jq '.download_url' -r) --output core18.snap && \
    mkdir -p /snap/core18 && \
    unsquashfs -d /snap/core18/current core18.snap && \
    rm -f core18.snap && \
    curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/snapcraft?channel=5.x/stable' | jq '.download_url' -r) --output snapcraft.snap && \
    mkdir -p /snap/snapcraft && \
    unsquashfs -d /snap/snapcraft/current snapcraft.snap && \
    rm -f snapcraft.snap && \
    mkdir -p /snap/bin && \
    echo "#!/bin/sh" > /snap/bin/snapcraft && \
    snap_version="$(awk '/^version:/{print $2}' /snap/snapcraft/current/meta/snap.yaml)" && \
    echo "export SNAP_VERSION=\"$snap_version\"" >> /snap/bin/snapcraft && \
    echo 'exec "$SNAP/usr/bin/python3" "$SNAP/bin/snapcraft" "$@"' >> /snap/bin/snapcraft && \
    chmod +x /snap/bin/snapcraft && \
    mkdir /build && cd /build && \
    PROTOBUF_VERSION=3.4.1 && \
    PROTOBUF_SHA256=2bb34b4a8211a30d12ef29fd8660995023d119c99fbab2e5fe46f17528c9cc78 && \
    wget -q https://github.com/google/protobuf/releases/download/v$PROTOBUF_VERSION/protobuf-cpp-$PROTOBUF_VERSION.tar.gz && \
    echo $PROTOBUF_SHA256 protobuf-cpp-$PROTOBUF_VERSION.tar.gz | sha256sum -c && \
    tar xzfo protobuf-cpp-$PROTOBUF_VERSION.tar.gz && \
    cd protobuf-$PROTOBUF_VERSION && \
# force include <algorithm> \
    sed -i.orig 's,#ifdef _MSC_VER,#if 1,' "src/google/protobuf/repeated_field.h" && \
    cmake  -S cmake -B build -DBUILD_SHARED_LIBS=OFF -Dprotobuf_BUILD_TESTS=OFF -Dprotobuf_BUILD_EXAMPLES=OFF && \
    cmake --build build --parallel $CORES && cmake --install build --prefix /opt/protobuf && \
    rm -rf /build/*

USER videolan
