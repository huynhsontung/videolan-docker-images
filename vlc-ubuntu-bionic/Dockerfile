FROM ubuntu:bionic-20190307

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=201906271059
ENV LANG=en_US.UTF-8
ENV PATH=$PATH:/usr/sbin

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
    apt-get update && apt-get install -y --no-install-suggests --no-install-recommends \
      gnupg1 && \
    echo "deb http://archive.neon.kde.org/user bionic main" >> /etc/apt/sources.list.d/neon.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E6D4736255751E5D && \
    apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends \
      ant autoconf automake autopoint bison cmake flex g++ gettext \
      git git-core libasound2-dev libavahi-client-dev libcdio-dev libdbus-1-dev \
      libdirectfb-dev libegl1-mesa-dev libfreerdp-dev libfreetype6-dev libfribidi-dev \
      libgles2-mesa-dev libgnutls28-dev libgtk2.0-dev libidn11-dev libjack-dev \
      liblircclient-dev libltdl-dev liblua5.2-dev libmtp-dev libncursesw5-dev \
      libpng-dev libpulse-dev libqt5svg5-dev libqt5x11extras5-dev librsvg2-dev \
      libsecret-1-dev libtool libtool-bin libudev-dev libupnp-dev libv4l-dev \
      libva-dev libvdpau-dev libx11-dev libxcb-composite0-dev libxcb-keysyms1-dev \
      libxcb-randr0-dev libxcb-shm0-dev libxcb-xfixes0-dev libxcb-xv0-dev libxcb1-dev \
      libxext-dev libxi-dev libxinerama-dev libxml2-dev libxpm-dev libzvbi-dev \
      locales lua5.2 make pkg-config p7zip-full qtbase5-dev qtbase5-private-dev ragel snapcraft \
      vim xz-utils yasm zlib1g-dev libxkbcommon-x11-dev meson  \
      curl build-essential python3-pip python3-setuptools python3-wheel \
      nasm clang libvulkan-dev qtdeclarative5-dev qtquickcontrols2-5-dev \
      qml-module-qtquick-controls2 qml-module-qtquick-layouts qml-module-qtquick-templates2 \
      qml-module-qtgraphicaleffects gnupg1 ca-certificates lftp openjdk-11-jdk \
      && \
    pip3 install meson ninja && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8 && \
    echo "export PATH=\$PATH:/usr/sbin" >> /etc/profile.d/vlc_env.sh && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10

USER videolan
