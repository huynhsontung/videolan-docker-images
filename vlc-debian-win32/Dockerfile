FROM registry.videolan.org:5000/videolan-base-stretch:latest

ENV IMAGE_DATE=201803261800

COPY scripts/wait_process.sh /opt/wine/
COPY patches /patches

RUN set -x && \
    mkdir /build/ && \
    apt-get update -qq && apt-get install -qqy \
    git wget bzip2 file libwine-dev unzip libtool pkg-config cmake \
    build-essential automake texinfo ragel yasm p7zip-full autopoint \
    gettext dos2unix zip wine nsis curl gperf flex bison \
    libcurl4-gnutls-dev python3 python3-requests && \
    dpkg --add-architecture i386 && \
    apt-get update && apt-get -y install wine32 && \
    echo "deb http://deb.debian.org/debian experimental main" > /etc/apt/sources.list.d/experimental.list && \
    apt-get update && apt-get -y -t experimental install nsis && \
    rm -f /etc/apt/sources.list.d/experimental.list && \
    echo "deb http://deb.debian.org/debian testing main" > /etc/apt/sources.list.d/testing.list && \
    apt-get update && apt-get -y -t testing install nasm && \
    rm -f /etc/apt/sources.list.d/testing.list && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    \
    TARGET_TUPLE=i686-w64-mingw32 \
    TOOLCHAIN_PREFIX=/opt/gcc-$TARGET_TUPLE \
    MINGW_PREFIX=$TOOLCHAIN_PREFIX/$TARGET_TUPLE \
    PATH=$TOOLCHAIN_PREFIX/bin:$PATH \
    GCC_VERSION=6.4.0 \
    BINUTILS_VERSION=2.27 \
    MPFR_VERSION=3.1.6 \
    GMP_VERSION=6.1.1 \
    MPC_VERSION=1.0.3 && \
    \
    cd /build && \
    mkdir $TOOLCHAIN_PREFIX && \
    mkdir $MINGW_PREFIX && \
    ln -s $MINGW_PREFIX $TOOLCHAIN_PREFIX/mingw && \
    wget -q http://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.bz2 && \
    wget -q ftp://ftp.uvsq.fr/pub/gcc/releases/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz && \
    git config --global user.name "VideoLAN Buildbot" && \
    git config --global user.email buildbot@videolan.org && \
    git clone --depth=1 --branch v5.0.3 git://git.code.sf.net/p/mingw-w64/mingw-w64 && \
    tar xf gcc-$GCC_VERSION.tar.xz && \
    tar xf binutils-$BINUTILS_VERSION.tar.bz2 && \
    cd binutils-$BINUTILS_VERSION && mkdir build && cd build && \
    ../configure --prefix=$TOOLCHAIN_PREFIX --target=$TARGET_TUPLE \
                    --disable-werror --disable-multilib && make -j4 && make install && \
    cd /build/mingw-w64/mingw-w64-headers && mkdir build && cd build && \
    ../configure --prefix=$MINGW_PREFIX \
                    --host=$TARGET_TUPLE --enable-secure-api && make install && \
    cd /build && \
    wget -q https://ftp.gnu.org/gnu/mpfr/mpfr-$MPFR_VERSION.tar.gz && \
    wget -q https://gmplib.org/download/gmp/gmp-$GMP_VERSION.tar.xz && \
    wget -q ftp://ftp.gnu.org/gnu/mpc/mpc-$MPC_VERSION.tar.gz && \
    tar xf mpfr-$MPFR_VERSION.tar.gz && \
    tar xf gmp-$GMP_VERSION.tar.xz && \
    tar xf mpc-$MPC_VERSION.tar.gz && \
    ln -s /build/mpfr-$MPFR_VERSION gcc-$GCC_VERSION/mpfr && \
    ln -s /build/gmp-$GMP_VERSION gcc-$GCC_VERSION/gmp && \
    ln -s /build/mpc-$MPC_VERSION gcc-$GCC_VERSION/mpc && \
    cd /build/gcc-$GCC_VERSION && patch -p0 < /patches/libstdcxx.patch && \
    patch -p0 < /patches/gcc-configure-ac.patch && \
    autoreconf -vif && cd libstdc++-v3/ && autoreconf && \
    cd /build/gcc-$GCC_VERSION && \
    mkdir build && cd build && \
    ../configure --prefix=$TOOLCHAIN_PREFIX \
                    --target=$TARGET_TUPLE \
                    --enable-languages=c,c++ \
                    --enable-lto \
                    --disable-shared \
                    --disable-multilib && \
                    make -j4 all-gcc && \
                    make install-gcc && \
    cd /build/mingw-w64/mingw-w64-crt && \
    mkdir build && cd build && \
    ../configure --prefix=$MINGW_PREFIX \
                    --host=$TARGET_TUPLE && \
    make -j4 && \
    make install && \
    cd /build/gcc-$GCC_VERSION/build && \
    make -j4 && \
    make install && \
    cd /build/mingw-w64/mingw-w64-tools/widl && \
    mkdir build && cd build && \
    ../configure --prefix=$TOOLCHAIN_PREFIX --target=$TARGET_TUPLE && \
    make -j4 && \
    make install && \
    cd /build/ && git clone --recursive https://code.videolan.org/videolan/breakpad.git && \
    cd breakpad && autoreconf -vif && mkdir build && cd build && \
    ../configure --enable-tools --disable-processor --prefix=/opt/breakpad && \
    make -j4 && make install && \
    \
    chmod +x /opt/wine/wait_process.sh && \
    wget https://raw.githubusercontent.com/Winetricks/winetricks/d30478da6981e0842956e5b326339b52540efaec/src/winetricks -O /opt/wine/winetricks && \
    chmod +x /opt/wine/winetricks && \
    WINE_MONO_VERSION=4.5.6 && mkdir -p /usr/share/wine/mono \
	&& wget "http://sourceforge.net/projects/wine/files/Wine%20Mono/$WINE_MONO_VERSION/wine-mono-$WINE_MONO_VERSION.msi/download" -O /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi && \
    chmod +x /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi && \
    cd / && rm -rf /build

USER jenkins
RUN wine wineboot --init && \
    /opt/wine/wait_process.sh wineserver && \
    /opt/wine/winetricks --unattended dotnet40 dotnet_verifier && \
    /opt/wine/wait_process.sh wineserver && \
    wget https://download.videolan.org/contrib/wix/wix-3.5.msi -O ~/wix.msi && \
    wine msiexec /i ~/wix.msi && \
    cd ~/ && \
    rm -f ~/wix.msi

USER root
