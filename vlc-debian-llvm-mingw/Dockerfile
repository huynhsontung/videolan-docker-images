FROM debian:testing-20200514-slim

MAINTAINER VideoLAN roots <roots@videolan.org>
 
ENV IMAGE_DATE=202004161126

RUN apt-get update -qq && mkdir -p /usr/share/man/man1 && \
    apt-get upgrade -y && \
    apt-get install -qqy --no-install-suggests --no-install-recommends \
    git wget bzip2 file unzip libtool-bin pkg-config build-essential \
    automake yasm gettext autopoint vim python git-svn ninja-build libwine-development \
    wine-development flex ragel bison zip dos2unix p7zip-full subversion gperf nsis nasm \
    python3 locales meson libltdl-dev ca-certificates curl default-jdk-headless && \
    dpkg --add-architecture i386 && \
    apt-get update && apt-get -y install --no-install-suggests --no-install-recommends wine32-development && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.UTF-8

RUN git config --global user.name "LLVM MinGW" && \
    git config --global user.email root@localhost

WORKDIR /build

ENV TOOLCHAIN_PREFIX=/opt/llvm-mingw

ARG TOOLCHAIN_ARCHS="i686 x86_64 armv7 aarch64"

ENV CORES=4

RUN CMAKE_VERSION=3.17.0 && \
    CMAKE_SHA256=b74c05b55115eacc4fa2b77a814981dbda05cdc95a53e279fe16b7b272f00847 && \
    wget -q http://www.cmake.org/files/v3.17/cmake-$CMAKE_VERSION.tar.gz && \
    echo $CMAKE_SHA256 cmake-$CMAKE_VERSION.tar.gz | sha256sum -c && \
    tar xzf cmake-$CMAKE_VERSION.tar.gz && \
    cd cmake-$CMAKE_VERSION && ./configure --prefix=/opt/tools/ --parallel=$CORES --no-qt-gui -- \
        -DCMAKE_USE_OPENSSL:BOOL=OFF -DBUILD_TESTING:BOOL=OFF && make -j$CORES && make install && \
    rm -rf /build/*

ENV PATH=/opt/tools/bin:$PATH

# Build everything that uses the llvm monorepo. We need to build the mingw runtime before the compiler-rt/libunwind/libcxxabi/libcxx runtimes.
COPY build-llvm.sh strip-llvm.sh install-wrappers.sh build-mingw-w64.sh build-compiler-rt.sh build-mingw-w64-libraries.sh build-libcxx.sh ./
COPY wrappers/*.sh wrappers/*.c wrappers/*.h ./wrappers/
RUN ./build-llvm.sh $TOOLCHAIN_PREFIX && \
    ./strip-llvm.sh $TOOLCHAIN_PREFIX && \
    ./install-wrappers.sh $TOOLCHAIN_PREFIX && \
    ./build-mingw-w64.sh $TOOLCHAIN_PREFIX --with-default-msvcrt=msvcrt && \
    ./build-compiler-rt.sh $TOOLCHAIN_PREFIX && \
    ./build-mingw-w64-libraries.sh $TOOLCHAIN_PREFIX && \
    ./build-libcxx.sh $TOOLCHAIN_PREFIX && \
    ./build-compiler-rt.sh $TOOLCHAIN_PREFIX --build-sanitizers && \
    rm -rf /build/*

# Build libssp
COPY build-libssp.sh libssp-Makefile ./
RUN ./build-libssp.sh $TOOLCHAIN_PREFIX && \
    rm -rf /build/*

COPY scripts/wait_process.sh /opt/wine/
RUN wget -q https://raw.githubusercontent.com/Winetricks/winetricks/d30478da6981e0842956e5b326339b52540efaec/src/winetricks -O /opt/wine/winetricks && \
    WINETRICKS_SHA256=01ebb56d22f54467343700eedfe283d82a47e67bbb6c2d68b7da743f41bb78a3 && \
    echo $WINETRICKS_SHA256 /opt/wine/winetricks | sha256sum -c && \
    chmod +x /opt/wine/winetricks && \
    WINE_MONO_VERSION=4.5.6 && mkdir -p /usr/share/wine/mono && \
    wget -q "https://download.videolan.org/contrib/wine-mono/wine-mono-$WINE_MONO_VERSION.msi" -O /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi && \
    WINE_MONO_SHA256=ac681f737f83742d786706529eb85f4bc8d6bdddd8dcdfa9e2e336b71973bc25 && \
    echo $WINE_MONO_SHA256 /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi | sha256sum -c && \
    chmod +x /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the videolan user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG VIDEOLAN_UID=499

RUN addgroup --quiet --gid ${VIDEOLAN_UID} videolan && \
    adduser --quiet --uid ${VIDEOLAN_UID} --ingroup videolan videolan && \
    echo "videolan:videolan" | chpasswd

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
    rm -rf ~/.cache/winetricks && \
    rm -rf /tmp/wine-*

ENV PATH=$TOOLCHAIN_PREFIX/bin:$PATH

COPY crossfiles /opt/crossfiles

