FROM registry.videolan.org:5000/videolan-base-stretch:latest

ENV IMAGE_DATE=201712181741

# We still need an i686 cross compiler to build the installer
RUN set -x && \
    apt-get update -qq && apt-get install -qqy \
    git wget bzip2 file libwine-dev unzip libtool pkg-config cmake \
    build-essential automake texinfo ragel yasm p7zip-full autopoint \
    gettext dos2unix zip wine nsis g++-mingw-w64-i686 gperf flex bison && \
    echo "deb http://deb.debian.org/debian experimental main" > /etc/apt/sources.list.d/experimental.list && \
    apt-get update && apt-get -y -t experimental install nsis && \
    rm -f /etc/apt/sources.list.d/experimental.list && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    \
    TARGET_TUPLE=x86_64-w64-mingw32 \
    TOOLCHAIN_PREFIX=/opt/gcc-$TARGET_TUPLE \
    MINGW_PREFIX=$TOOLCHAIN_PREFIX/$TARGET_TUPLE \
    PATH=$TOOLCHAIN_PREFIX/bin:$PATH \
    GCC_VERSION=6.4.0 \
    BINUTILS_VERSION=2.27 \
    MPFR_VERSION=3.1.6 \
    GMP_VERSION=6.1.1 \
    MPC_VERSION=1.0.3 && \
    \
    mkdir /build && cd /build && \
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
    wget -q http://www.mpfr.org/mpfr-current/mpfr-$MPFR_VERSION.tar.gz && \
    wget -q https://gmplib.org/download/gmp/gmp-$GMP_VERSION.tar.xz && \
    wget -q ftp://ftp.gnu.org/gnu/mpc/mpc-$MPC_VERSION.tar.gz && \
    tar xf mpfr-$MPFR_VERSION.tar.gz && \
    tar xf gmp-$GMP_VERSION.tar.xz && \
    tar xf mpc-$MPC_VERSION.tar.gz && \
    ln -s /build/mpfr-$MPFR_VERSION gcc-$GCC_VERSION/mpfr && \
    ln -s /build/gmp-$GMP_VERSION gcc-$GCC_VERSION/gmp && \
    ln -s /build/mpc-$MPC_VERSION gcc-$GCC_VERSION/mpc && \
    sed -i '79i#define _GLIBCXX_USE_WEAK_REF 0' \
        gcc-$GCC_VERSION/libstdc++-v3/config/os/mingw32-w64/os_defines.h && \
    cd gcc-$GCC_VERSION && mkdir build && cd build && \
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
    cd / && rm -rf /build
