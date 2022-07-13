FROM debian:sid-20220125-slim

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=202207050922

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the videolan user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG VIDEOLAN_UID=499

ARG CORES=8

RUN set -x && \
    addgroup --quiet --gid ${VIDEOLAN_UID} videolan && \
    adduser --quiet --uid ${VIDEOLAN_UID} --ingroup videolan videolan && \
    echo "videolan:videolan" | chpasswd && \
    mkdir -p /usr/share/man/man1 && \
    echo "deb http://ftp.fr.debian.org/debian/ sid main" > /etc/apt/sources.list && \
    echo "deb-src http://ftp.fr.debian.org/debian/ sid main" >> /etc/apt/sources.list && \
    apt-get update && apt-get install -yq --no-install-suggests --no-install-recommends \
    ca-certificates git-core libtool automake autoconf autopoint ninja-build python3 \
    libavformat-dev libavutil-dev libpostproc-dev libswscale-dev \
    gettext pkg-config wget m4 build-essential curl libltdl-dev meson flex bison \
    rapidjson-dev libsqlite3-dev lcov libmpg123-dev libtag-extras-dev liba52-dev \
    liba52-0.7.4-dev liblua5.1-0-dev zlib1g-dev libjpeg62-turbo-dev libxml2-dev gcovr \
    gdb libid3-tools python3-scipy cmake sqlite3 libtag1-dev libxxhash-dev \
    clang libc++-dev libc++abi-dev llvm-13 && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    mkdir /build && cd /build && \
    git clone --depth=1 https://code.videolan.org/videolan/vlc.git --single-branch --branch=3.0.x && \
    cd vlc && \
    git config --global user.name 'VideoLAN CI' && \
    git config --global user.email 'root@videolan.org' && \
    mkdir contrib/native && cd contrib/native && \
    ../bootstrap && make .dvdread .dvdnav -j$CORES && \
    cd ../.. && \
    ./bootstrap && mkdir build && cd build && \
    ../configure --disable-lua --disable-qt --disable-skins2 \
        --disable-nls --disable-xcb --disable-alsa \
        --prefix=/prefix && \
    make -j$CORES && make install && \
    cd / && \
    git clone --depth=1 --single-branch --branch=v1.6.0 https://github.com/google/benchmark.git && \
    cd /build && mkdir benchmark && cd benchmark && \
    cmake -DCMAKE_BUILD_TYPE=Release \
        -DBENCHMARK_ENABLE_GTEST_TESTS=OFF \
        -DCMAKE_INSTALL_PREFIX=/prefix \
        -DBENCHMARK_ENABLE_TESTING=OFF \
        /benchmark && \
    make -j$CORES && make install && \
    rm -rf /build

ENV PKG_CONFIG_PATH=/prefix/lib/pkgconfig 

USER videolan
