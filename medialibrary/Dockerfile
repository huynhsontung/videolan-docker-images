FROM debian:sid-20200224-slim

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=202003271228

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
    apt-get update && apt-get install -yq --no-install-suggests --no-install-recommends \
    ca-certificates git-core libtool automake autoconf autopoint ninja-build python3 \
    libavformat-dev libavresample-dev libavutil-dev libpostproc-dev libswscale-dev \
    gettext pkg-config wget m4 build-essential curl libltdl-dev meson flex bison \
    rapidjson-dev libsqlite3-dev lcov libmpg123-dev libtag-extras-dev liba52-dev \
    liba52-0.7.4-dev liblua5.1-0-dev zlib1g-dev libjpeg62-turbo-dev libxml2-dev && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    cd / && \
    git clone --depth=1 https://git.videolan.org/git/vlc/vlc-3.0.git && \
    cd vlc-3.0 && \
    git config --global user.name 'VideoLAN CI' && \
    git config --global user.email 'root@videolan.org' && \
    mkdir contrib/native && cd contrib/native && \
    ../bootstrap && make .dvdread .dvdnav -j4 && \
    cd ../.. && \
    ./bootstrap && mkdir build && cd build && \
    ../configure --disable-lua --disable-qt --disable-skins2 \
        --disable-nls --disable-xcb --disable-alsa \
        --prefix=/prefix && \
    make -j4 && make install && \
    git clone https://code.videolan.org/videolan/libvlcpp.git && \
    cd libvlcpp && ./bootstrap && \
    ./configure --prefix=/prefix/ && \
    make -j4 && make install

ENV PKG_CONFIG_PATH=/prefix/lib/pkgconfig 

USER videolan
