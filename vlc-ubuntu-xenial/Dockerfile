FROM registry.videolan.org:5000/videolan-base-xenial:20180529123029

ENV IMAGE_DATE=201805311600

RUN echo "deb http://archive.neon.kde.org/user xenial main" >> /etc/apt/sources.list.d/neon.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E6D4736255751E5D && \
    apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends -y \
      ant autoconf automake autopoint bison build-essential cmake flex g++ gettext \
      git git-core libasound2-dev libavahi-client-dev libcdio-dev libdbus-1-dev \
      libdirectfb-dev libegl1-mesa-dev libfreerdp-dev libfreetype6-dev libfribidi-dev \
      libgles2-mesa-dev libgnutls28-dev libgtk2.0-dev libidn11-dev libjack-dev \
      liblircclient-dev libltdl-dev liblua5.2-dev libmtp-dev libncursesw5-dev \
      libpng-dev libpulse-dev libqt5svg5-dev libqt5x11extras5-dev librsvg2-dev \
      libsecret-1-dev libtool libtool-bin libudev-dev libupnp-dev libv4l-dev \
      libva-dev libvdpau-dev libx11-dev libxcb-composite0-dev libxcb-keysyms1-dev \
      libxcb-randr0-dev libxcb-shm0-dev libxcb-xfixes0-dev libxcb-xv0-dev libxcb1-dev \
      libxext-dev libxi-dev libxinerama-dev libxml2-dev libxpm-dev libzvbi-dev \
      locales lua5.2 make pkg-config qtbase5-dev qtbase5-private-dev ragel snapcraft \
      vim xz-utils yasm zlib1g-dev libxkbcommon-x11-dev \
    && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8
