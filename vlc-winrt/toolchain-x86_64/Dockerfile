FROM videolan-base-sid:latest

MAINTAINER Hugo Beauzée-Luyssen <hugo@beauzee.fr>

RUN apt-get update -qq && apt-get install -qqy \
    git wget bzip2 file libwine-dev unzip libtool pkg-config cmake \
    build-essential automake texinfo ragel yasm p7zip-full && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

ENV TARGET_TUPLE=x86_64-w64-mingw32
ENV TOOLCHAIN_PREFIX=/opt/gcc-$TARGET_TUPLE
ENV MINGW_PREFIX=$TOOLCHAIN_PREFIX/$TARGET_TUPLE
ENV PATH=$TOOLCHAIN_PREFIX/bin:$PATH

COPY no-rtl-func.patch .

RUN mkdir /build && cd /build && \
    mkdir $TOOLCHAIN_PREFIX && \
    mkdir $MINGW_PREFIX && \
    ln -s $MINGW_PREFIX $TOOLCHAIN_PREFIX/mingw && \
    wget -q http://ftp.gnu.org/gnu/binutils/binutils-2.26.tar.bz2 && \
    wget -q ftp://ftp.uvsq.fr/pub/gcc/releases/gcc-5.3.0/gcc-5.3.0.tar.bz2 && \
    git config --global user.name "VideoLAN Buildbot" && \
    git config --global user.email buildbot@videolan.org && \
    git clone --depth=1 git://git.code.sf.net/p/mingw-w64/mingw-w64 && \
    cd mingw-w64 && git am ../../no-rtl-func.patch && cd .. && \
    tar xf gcc-5.3.0.tar.bz2 && \
    tar xf binutils-2.26.tar.bz2 && \
    cd binutils-2.26 && mkdir build && cd build && \
    ../configure --prefix=$TOOLCHAIN_PREFIX --target=$TARGET_TUPLE \
                    --disable-werror --disable-multilib && make -j4 && make install && \
    cd /build/mingw-w64/mingw-w64-headers && mkdir build && cd build && \
    ../configure --prefix=$MINGW_PREFIX \
                    --host=$TARGET_TUPLE && make install && \
    cd /build && \
    wget -q http://www.mpfr.org/mpfr-current/mpfr-3.1.4.tar.gz && \
    wget -q https://gmplib.org/download/gmp/gmp-6.1.0.tar.xz && \
    wget -q ftp://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz && \
    tar xf mpfr-3.1.4.tar.gz && \
    tar xf gmp-6.1.0.tar.xz && \
    tar xf mpc-1.0.3.tar.gz && \
    ln -s /build/mpfr-3.1.4 gcc-5.3.0/mpfr && \
    ln -s /build/gmp-6.1.0 gcc-5.3.0/gmp && \
    ln -s /build/mpc-1.0.3 gcc-5.3.0/mpc && \
    cd gcc-5.3.0 && mkdir build && cd build && \
    ../configure --prefix=$TOOLCHAIN_PREFIX \
                    --target=$TARGET_TUPLE \
                    --enable-languages=c,c++ \
                    --disable-shared \
                    --disable-multilib \
                    --enable-sjlj-exceptions && \
                    make -j4 all-gcc && \
                    make install-gcc && \
    cd /build/mingw-w64/mingw-w64-crt && \
    autoreconf -vif && \
    mkdir build && cd build && \
    ../configure --prefix=$MINGW_PREFIX \
                    --host=$TARGET_TUPLE && \
    make -j4 && \
    make install && \
    cd /build/gcc-5.3.0/build && \
    make -j4 && \
    make install && \
    cd /build/mingw-w64/mingw-w64-libraries/winstorecompat && \
    autoreconf -vif && \
    mkdir build && cd build && \
    ../configure --prefix=$MINGW_PREFIX \
        --host=$TARGET_TUPLE && \
    make -j4 && make install && \
    cd /build/mingw-w64/mingw-w64-tools/widl && \
    mkdir build && cd build && \
    ../configure --prefix=$TOOLCHAIN_PREFIX --target=$TARGET_TUPLE && \
    make -j4 && \
    make install && \
    cd / && rm -rf /build
