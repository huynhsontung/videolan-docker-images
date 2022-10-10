FROM debian:bullseye-20211220-slim

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the videolan user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG VIDEOLAN_UID=499
# 8 cores ought to be enough for anybody
ARG CORES=8

ENV IMAGE_DATE=202214171500

ENV TARGET_TUPLE=i686-w64-mingw32
ENV TOOLCHAIN_PREFIX=/opt/gcc-$TARGET_TUPLE
ENV MINGW_PREFIX=$TOOLCHAIN_PREFIX/$TARGET_TUPLE
ENV PATH=$TOOLCHAIN_PREFIX/bin:/opt/cmake/bin:/opt/protobuf/bin:$PATH

# The wine SDK path differs from version to version, starting from the one in buster, it's
# located in /usr/include/wine/wine/windows/ instead of
# /usr/include/wine/windows/
ENV WINE_SDK_PATH=/usr/include/wine/wine/windows

COPY scripts/wait_process.sh /opt/wine/
COPY patches /patches

RUN set -x && \
    mkdir -p /usr/share/man/man1 && \
    addgroup --quiet --gid ${VIDEOLAN_UID} videolan && \
    adduser --quiet --uid ${VIDEOLAN_UID} --ingroup videolan videolan && \
    echo "videolan:videolan" | chpasswd && \
    echo "export TARGET_TUPLE=${TARGET_TUPLE}" >> /etc/profile.d/vlc_env.sh && \
    echo "export TOOLCHAIN_PREFIX=${TOOLCHAIN_PREFIX}" >> /etc/profile.d/vlc_env.sh && \
    echo "export MINGW_PREFIX=${MINGW_PREFIX}" >> /etc/profile.d/vlc_env.sh && \
    echo "export PATH=${TOOLCHAIN_PREFIX}/bin:\$PATH" >> /etc/profile.d/vlc_env.sh && \
    apt-get update -qq && apt-get install -qqy --no-install-suggests --no-install-recommends \
    git wget bzip2 file libwine-dev unzip libtool libtool-bin libltdl-dev pkg-config ant \
    build-essential automake texinfo ragel yasm p7zip-full autopoint \
    gettext dos2unix zip wine nsis curl gperf flex bison \
    libcurl4-gnutls-dev python3 python3-setuptools python3-mako python3-requests \
    lftp gcc make procps ca-certificates \
    openjdk-11-jdk-headless locales nsis nasm jq gnupg \
    && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    dpkg --add-architecture i386 && \
    apt-get update && apt-get -y install --no-install-suggests --no-install-recommends wine32 && \
    echo "deb http://deb.debian.org/debian testing main" > /etc/apt/sources.list.d/testing.list && \
    apt-get update && apt-get -y -t testing --no-install-suggests --no-install-recommends install \
    nasm meson autoconf autoconf2.69 && \
    rm -f /etc/apt/sources.list.d/testing.list && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && rm -f winehq.key && \
    echo "deb https://dl.winehq.org/wine-builds/debian/ bullseye main" > /etc/apt/sources.list.d/winehq.list && \
    apt-get update && apt-get -y install winehq-stable && \
    rm -f /etc/apt/sources.list.d/winehq.list && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1 && \
    \
    GCC_VERSION=11.2.0 \
    GCC_SHA256=d08edc536b54c372a1010ff6619dd274c0f1603aa49212ba20f7aa2cda36fa8b \
    BINUTILS_VERSION=2.27 \
    BINUTILS_SHA256=369737ce51587f92466041a97ab7d2358c6d9e1b6490b3940eb09fb0a9a6ac88 \
    MPFR_VERSION=3.1.6 \
    MPFR_SHA256=569ceb418aa935317a79e93b87eeb3f956cab1a97dfb2f3b5fd8ac2501011d62 \
    GMP_VERSION=6.1.1 \
    GMP_SHA256=d36e9c05df488ad630fff17edb50051d6432357f9ce04e34a09b3d818825e831 \
    MPC_VERSION=1.0.3 \
    MPC_SHA256=617decc6ea09889fb08ede330917a00b16809b8db88c29c31bfbb49cbf88ecc3 \
    MINGW_W64_HASH=aa08f56da559016f10336dddca85d59f9bdc9e02 \
    && \
    mkdir /build/ && \
    cd /build && \
    mkdir $TOOLCHAIN_PREFIX && \
    mkdir $MINGW_PREFIX && \
    ln -s $MINGW_PREFIX $TOOLCHAIN_PREFIX/mingw && \
    wget -q https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.bz2 && \
    echo $BINUTILS_SHA256 binutils-$BINUTILS_VERSION.tar.bz2 | sha256sum -c && \
    wget -q https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz && \
    echo $GCC_SHA256 gcc-$GCC_VERSION.tar.xz | sha256sum -c && \
    git config --global user.name "VideoLAN Buildbot" && \
    git config --global user.email buildbot@videolan.org && \
    git clone -n --single-branch git://git.code.sf.net/p/mingw-w64/mingw-w64 && \
    tar xf gcc-$GCC_VERSION.tar.xz && \
    tar xf binutils-$BINUTILS_VERSION.tar.bz2 && \
    cd binutils-$BINUTILS_VERSION && mkdir build && cd build && \
    ../configure --prefix=$TOOLCHAIN_PREFIX --target=$TARGET_TUPLE \
                    --disable-werror --disable-multilib && make -j$CORES && make install-strip && \
    cd /build/mingw-w64 && git checkout $MINGW_W64_HASH && autoreconf -vif && \
    cd /build/mingw-w64/mingw-w64-headers && mkdir build && cd build && \
    ../configure --prefix=$MINGW_PREFIX \
                    --host=$TARGET_TUPLE && make install && \
    cd /build && \
    wget -q https://ftp.gnu.org/gnu/mpfr/mpfr-$MPFR_VERSION.tar.gz && \
    echo $MPFR_SHA256 mpfr-$MPFR_VERSION.tar.gz | sha256sum -c && \
    wget -q https://download.videolan.org/contrib/gmp/gmp-$GMP_VERSION.tar.xz && \
    echo $GMP_SHA256 gmp-$GMP_VERSION.tar.xz | sha256sum -c && \
    wget -q https://ftp.gnu.org/gnu/mpc/mpc-$MPC_VERSION.tar.gz && \
    echo $MPC_SHA256 mpc-$MPC_VERSION.tar.gz | sha256sum -c && \
    tar xf mpfr-$MPFR_VERSION.tar.gz && \
    tar xf gmp-$GMP_VERSION.tar.xz && \
    tar xf mpc-$MPC_VERSION.tar.gz && \
    ln -s /build/mpfr-$MPFR_VERSION gcc-$GCC_VERSION/mpfr && \
    ln -s /build/gmp-$GMP_VERSION gcc-$GCC_VERSION/gmp && \
    ln -s /build/mpc-$MPC_VERSION gcc-$GCC_VERSION/mpc && \
    cd /build/gcc-$GCC_VERSION && patch -p0 < /patches/libstdcxx.patch && \
    autoreconf2.69 -vif && cd libstdc++-v3/ && autoreconf2.69 && \
    cd /build/gcc-$GCC_VERSION && \
    mkdir build && cd build && \
    ../configure --prefix=$TOOLCHAIN_PREFIX \
                    --target=$TARGET_TUPLE \
                    --enable-languages=c,c++ \
                    --enable-lto \
                    --disable-shared \
                    --disable-multilib && \
                    make -j$CORES all-gcc && \
                    make install-gcc && \
    cd /build/mingw-w64/mingw-w64-crt && \
    mkdir build && cd build && \
    ../configure --prefix=$MINGW_PREFIX \
                    --host=$TARGET_TUPLE && \
    make -j$CORES && \
    make install && \
    cd /build/gcc-$GCC_VERSION/build && \
    make -j$CORES && \
    make install-strip && \
    cd /build/mingw-w64/mingw-w64-tools/widl && \
    mkdir build && cd build && \
    ../configure --prefix=$TOOLCHAIN_PREFIX --target=$TARGET_TUPLE && \
    make -j$CORES && \
    make install && \
    cd /build/mingw-w64/mingw-w64-libraries/winpthreads && \
    mkdir build && cd build && \
    ../configure --prefix=$TOOLCHAIN_PREFIX --host=$TARGET_TUPLE && \
    make -j$CORES && \
    make install && \
    cd /build/ && \
    BREAKPAD_VERSION=0.1.4 && \
    BREAKPAD_SHA256=020953390cce3a04ba859801bf863689a74e2aca0bd48ff256055f1c9af0e33a && \
    wget -q https://download.videolan.org/pub/contrib/breakpad/breakpad-$BREAKPAD_VERSION.tar.gz && \
    echo $BREAKPAD_SHA256 breakpad-$BREAKPAD_VERSION.tar.gz | sha256sum -c && \
    tar xzf breakpad-$BREAKPAD_VERSION.tar.gz && \
    cd breakpad-$BREAKPAD_VERSION && autoreconf -vif && mkdir build && cd build && \
    ../configure --enable-tools --disable-processor --prefix=/opt/breakpad && \
    make -j$CORES && make install && \
    \
    chmod +x /opt/wine/wait_process.sh && \
    wget -q https://raw.githubusercontent.com/Winetricks/winetricks/5028127369b7b23b03789aec083ba5b68aa1ec34/src/winetricks -O /opt/wine/winetricks && \
    WINETRICKS_SHA256=7ec9c3e9140e592ef575140417f27e75e16ccebfeee9816cdbab21aa3d5c0841 && \
    echo $WINETRICKS_SHA256 /opt/wine/winetricks | sha256sum -c && \
    chmod +x /opt/wine/winetricks && \
    WINE_MONO_VERSION=4.5.6 && mkdir -p /usr/share/wine/mono && \
    wget -q "https://download.videolan.org/contrib/wine-mono/wine-mono-$WINE_MONO_VERSION.msi" -O /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi && \
    WINE_MONO_SHA256=ac681f737f83742d786706529eb85f4bc8d6bdddd8dcdfa9e2e336b71973bc25 && \
    echo $WINE_MONO_SHA256 /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi | sha256sum -c && \
    chmod +x /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi && \
    cd /build && \
    CMAKE_VERSION=3.17.0 && \
    CMAKE_SHA256=b74c05b55115eacc4fa2b77a814981dbda05cdc95a53e279fe16b7b272f00847 && \
    wget -q https://www.cmake.org/files/v3.17/cmake-$CMAKE_VERSION.tar.gz && \
    echo $CMAKE_SHA256 cmake-$CMAKE_VERSION.tar.gz | sha256sum -c && \
    tar xzf cmake-$CMAKE_VERSION.tar.gz && \
    cd cmake-$CMAKE_VERSION && ./configure --prefix=/opt/cmake/ --parallel=$CORES --no-qt-gui -- \
        -DCMAKE_USE_OPENSSL:BOOL=OFF -DBUILD_TESTING:BOOL=OFF && make -j$CORES && make install && \
    cd /build && \
    PROTOBUF_VERSION=3.1.0 && \
    PROTOBUF_SHA256=51ceea9957c875bdedeb1f64396b5b0f3864fe830eed6a2d9c066448373ea2d6 && \
    wget -q https://github.com/google/protobuf/releases/download/v$PROTOBUF_VERSION/protobuf-cpp-$PROTOBUF_VERSION.tar.gz && \
    echo $PROTOBUF_SHA256 protobuf-cpp-$PROTOBUF_VERSION.tar.gz | sha256sum -c && \
    tar xzfo protobuf-cpp-$PROTOBUF_VERSION.tar.gz && \
    cd protobuf-$PROTOBUF_VERSION && \
    wget -q https://code.videolan.org/videolan/vlc/-/raw/c580054e4f3a166f93c91f94416f97d89be83c16/extras/tools/protobuf-fix-build.patch && \
    patch -p1 < protobuf-fix-build.patch && \
    ./configure --prefix=/opt/protobuf --disable-shared --enable-static && make -j$CORES && make install && \
    cd / && rm -rf /build

ENV LANG=en_US.UTF-8
USER videolan
RUN wine wineboot --init && \
    /opt/wine/wait_process.sh wineserver && \
    /opt/wine/winetricks --unattended dotnet40 dotnet_verifier && \
    /opt/wine/wait_process.sh wineserver && \
    wget -q https://download.videolan.org/contrib/wix/wix-3.5.msi -O ~/wix.msi && \
    WIX_SHA256=621b70e8761d5b940d8c32a42b0e92fd55767f8908a9b32e06bb3d12a30bc47b && \
    echo $WIX_SHA256 ~/wix.msi | sha256sum -c && \
    wine msiexec /i ~/wix.msi && \
    cd ~/ && \
    rm -f ~/wix.msi && \
    rm -rf ~/.cache/winetricks
