FROM registry.videolan.org/videolan-base-stretch:20190408162131

ENV IMAGE_DATE=201904101711

ENV TARGET_TUPLE=x86_64-w64-mingw32
ENV TOOLCHAIN_PREFIX=/opt/gcc-${TARGET_TUPLE}
ENV MINGW_PREFIX=$TOOLCHAIN_PREFIX/${TARGET_TUPLE}
ENV PATH=${TOOLCHAIN_PREFIX}/bin:${PATH}

COPY scripts/wait_process.sh /opt/wine/
COPY patches /patches

# We still need an i686 cross compiler to build the installer
RUN set -x && \
    echo "export TARGET_TUPLE=${TARGET_TUPLE}" >> /etc/profile.d/vlc_env.sh && \
    echo "export TOOLCHAIN_PREFIX=${TOOLCHAIN_PREFIX}" >> /etc/profile.d/vlc_env.sh && \
    echo "export MINGW_PREFIX=${MINGW_PREFIX}" >> /etc/profile.d/vlc_env.sh && \
    echo "export PATH=${TOOLCHAIN_PREFIX}/bin:\$PATH" >> /etc/profile.d/vlc_env.sh && \
    mkdir /build/ && \
    apt-get update -qq && apt-get install -qqy --no-install-suggests --no-install-recommends \
    git wget bzip2 file libwine-dev unzip libtool libtool-bin libltdl-dev pkg-config ant \
    build-essential automake texinfo ragel yasm p7zip-full autopoint \
    gettext dos2unix zip wine nsis g++-mingw-w64-i686 curl gperf flex bison \
    libcurl4-gnutls-dev python3 python3-requests && \
    dpkg --add-architecture i386 && \
    apt-get update && apt-get -y install --no-install-suggests --no-install-recommends wine32 && \
    echo "deb http://deb.debian.org/debian testing main" > /etc/apt/sources.list.d/testing.list && \
    apt-get update && apt-get -y -t testing --no-install-suggests --no-install-recommends install nasm nsis meson && \
    rm -f /etc/apt/sources.list.d/testing.list && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.5 1 && \
    \
    GCC_VERSION=6.4.0 \
    GCC_SHA256=850bf21eafdfe5cd5f6827148184c08c4a0852a37ccf36ce69855334d2c914d4 \
    BINUTILS_VERSION=2.34 \
    BINUTILS_SHA512=f47e7304e102c7bbc97958a08093e27796b9051d1567ce4fbb723d39ef3e29efa325ee14a1bdcc462a925a7f9bbbc9aee28294c6dc23850f371030f3835a8067 \
    MPFR_VERSION=3.1.6 \
    MPFR_SHA256=569ceb418aa935317a79e93b87eeb3f956cab1a97dfb2f3b5fd8ac2501011d62 \
    GMP_VERSION=6.1.1 \
    GMP_SHA256=d36e9c05df488ad630fff17edb50051d6432357f9ce04e34a09b3d818825e831 \
    MPC_VERSION=1.0.3 \
    MPC_SHA256=617decc6ea09889fb08ede330917a00b16809b8db88c29c31bfbb49cbf88ecc3 \
    && \
    cd /build && \
    mkdir $TOOLCHAIN_PREFIX && \
    mkdir $MINGW_PREFIX && \
    ln -s $MINGW_PREFIX $TOOLCHAIN_PREFIX/mingw && \
    wget -q http://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.bz2 && \
    echo $BINUTILS_SHA512 binutils-$BINUTILS_VERSION.tar.bz2 | sha512sum -c && \
    wget -q https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz && \
    echo $GCC_SHA256 gcc-$GCC_VERSION.tar.xz | sha256sum -c && \
    git config --global user.name "VideoLAN Buildbot" && \
    git config --global user.email buildbot@videolan.org && \
    git clone --depth=1 --branch v5.0.3 git://git.code.sf.net/p/mingw-w64/mingw-w64 && \
    tar xf gcc-$GCC_VERSION.tar.xz && \
    tar xf binutils-$BINUTILS_VERSION.tar.bz2 && \
    cd binutils-$BINUTILS_VERSION && mkdir build && cd build && \
    ../configure --prefix=$TOOLCHAIN_PREFIX --target=$TARGET_TUPLE \
                    --disable-werror --disable-multilib && make -j8 && make install-strip && \
    cd /build/mingw-w64/mingw-w64-headers && mkdir build && cd build && \
    ../configure --prefix=$MINGW_PREFIX \
                    --host=$TARGET_TUPLE --enable-secure-api && make install && \
    cd /build && \
    wget -q https://ftp.gnu.org/gnu/mpfr/mpfr-$MPFR_VERSION.tar.gz && \
    echo $MPFR_SHA256 mpfr-$MPFR_VERSION.tar.gz | sha256sum -c && \
    wget -q https://gmplib.org/download/gmp/gmp-$GMP_VERSION.tar.xz && \
    echo $GMP_SHA256 gmp-$GMP_VERSION.tar.xz | sha256sum -c && \
    wget -q https://ftp.gnu.org/gnu/mpc/mpc-$MPC_VERSION.tar.gz && \
    echo $MPC_SHA256 mpc-$MPC_VERSION.tar.gz | sha256sum -c && \
    tar xf mpfr-$MPFR_VERSION.tar.gz && \
    tar xf gmp-$GMP_VERSION.tar.xz && \
    tar xf mpc-$MPC_VERSION.tar.gz && \
    ln -s /build/mpfr-$MPFR_VERSION gcc-$GCC_VERSION/mpfr && \
    ln -s /build/gmp-$GMP_VERSION gcc-$GCC_VERSION/gmp && \
    ln -s /build/mpc-$MPC_VERSION gcc-$GCC_VERSION/mpc && \
    sed -i '79i#define _GLIBCXX_USE_WEAK_REF 0' \
        gcc-$GCC_VERSION/libstdc++-v3/config/os/mingw32-w64/os_defines.h && \
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
                    make -j8 all-gcc && \
                    make install-gcc && \
    cd /build/mingw-w64/mingw-w64-crt && \
    mkdir build && cd build && \
    ../configure --prefix=$MINGW_PREFIX \
                    --host=$TARGET_TUPLE && \
    make -j8 && \
    make install && \
    cd /build/gcc-$GCC_VERSION/build && \
    make -j8 && \
    make install-strip && \
    cd /build/mingw-w64/mingw-w64-tools/widl && \
    mkdir build && cd build && \
    ../configure --prefix=$TOOLCHAIN_PREFIX --target=$TARGET_TUPLE && \
    make -j8 && \
    make install && \
    cd /build/ && git clone --recursive https://code.videolan.org/videolan/breakpad.git && \
    cd breakpad && autoreconf -vif && mkdir build && cd build && \
    ../configure --enable-tools --disable-processor --prefix=/opt/breakpad && \
    make -j8 && make install && \
    \
    chmod +x /opt/wine/wait_process.sh && \
    wget -q https://raw.githubusercontent.com/Winetricks/winetricks/d30478da6981e0842956e5b326339b52540efaec/src/winetricks -O /opt/wine/winetricks && \
    WINETRICKS_SHA256=01ebb56d22f54467343700eedfe283d82a47e67bbb6c2d68b7da743f41bb78a3 && \
    echo $WINETRICKS_SHA256 /opt/wine/winetricks | sha256sum -c && \
    chmod +x /opt/wine/winetricks && \
    WINE_MONO_VERSION=4.5.6 && mkdir -p /usr/share/wine/mono && \
    wget -q "https://download.videolan.org/contrib/wine-mono/wine-mono-$WINE_MONO_VERSION.msi" -O /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi && \
    WINE_MONO_SHA256=ac681f737f83742d786706529eb85f4bc8d6bdddd8dcdfa9e2e336b71973bc25 && \
    echo $WINE_MONO_SHA256 /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi | sha256sum -c && \
    chmod +x /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi && \
    cd / && rm -rf /build

USER jenkins
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

USER root
