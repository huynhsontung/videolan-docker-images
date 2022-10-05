FROM debian:bullseye-20220801-slim

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=202206130000

# The wine SDK path differs from version to version, starting from the one in buster, it's
# located in /usr/include/wine/wine/windows/ instead of
# /usr/include/wine/windows/
ENV WINE_SDK_PATH=/usr/include/wine/wine/windows

RUN apt-get update -qq && mkdir -p /usr/share/man/man1 && \
    apt-get upgrade -y && \
    apt-get install -qqy --no-install-suggests --no-install-recommends \
    git wget bzip2 file unzip libtool-bin pkg-config build-essential \
    automake yasm gettext autopoint vim ninja-build ant \
    winbind flex ragel bison zip dos2unix p7zip-full gperf nsis nasm \
    python3 python3-setuptools python3-mako locales meson help2man libltdl-dev \
    ca-certificates curl default-jdk-headless gnupg procps && \
    dpkg --add-architecture i386 && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && rm -f winehq.key && \
    echo "deb https://dl.winehq.org/wine-builds/debian/ bullseye main" > /etc/apt/sources.list.d/winehq.list && \
    apt-get update && apt-get -y install winehq-stable && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1

ENV LANG=en_US.UTF-8

RUN git config --global user.name "LLVM MinGW" && \
    git config --global user.email root@localhost

WORKDIR /build

ENV TOOLCHAIN_PREFIX=/opt/llvm-mingw

ARG CORES=4

RUN CMAKE_VERSION=3.17.0 && \
    CMAKE_SHA256=b74c05b55115eacc4fa2b77a814981dbda05cdc95a53e279fe16b7b272f00847 && \
    wget -q http://www.cmake.org/files/v3.17/cmake-$CMAKE_VERSION.tar.gz && \
    echo $CMAKE_SHA256 cmake-$CMAKE_VERSION.tar.gz | sha256sum -c && \
    tar xzf cmake-$CMAKE_VERSION.tar.gz && \
    cd cmake-$CMAKE_VERSION && ./configure --prefix=/opt/tools/ --parallel=$CORES --no-qt-gui -- \
        -DCMAKE_USE_OPENSSL:BOOL=OFF -DBUILD_TESTING:BOOL=OFF && make -j$CORES && make install && \
    cd /build && \
    PROTOBUF_VERSION=3.1.0 && \
    PROTOBUF_SHA256=51ceea9957c875bdedeb1f64396b5b0f3864fe830eed6a2d9c066448373ea2d6 && \
    wget -q https://github.com/google/protobuf/releases/download/v$PROTOBUF_VERSION/protobuf-cpp-$PROTOBUF_VERSION.tar.gz && \
    echo $PROTOBUF_SHA256 protobuf-cpp-$PROTOBUF_VERSION.tar.gz | sha256sum -c && \
    tar xzfo protobuf-cpp-$PROTOBUF_VERSION.tar.gz && \
    cd protobuf-$PROTOBUF_VERSION && \
    ./configure --prefix=/opt/tools/ --disable-shared --enable-static && make -j$CORES && make install && \
    rm -rf /build/*

ENV PATH=/opt/tools/bin:$PATH

ARG TOOLCHAIN_ARCHS="i686 x86_64 armv7 aarch64"

ARG DEFAULT_CRT=ucrt

# Build everything that uses the llvm monorepo. We need to build the mingw runtime before the compiler-rt/libunwind/libcxxabi/libcxx runtimes.
COPY build-llvm.sh strip-llvm.sh install-wrappers.sh build-mingw-w64.sh build-mingw-w64-tools.sh build-compiler-rt.sh build-mingw-w64-libraries.sh build-libcxx.sh ./
COPY wrappers/*.sh wrappers/*.c wrappers/*.h ./wrappers/
RUN ./build-llvm.sh $TOOLCHAIN_PREFIX && \
    ./strip-llvm.sh $TOOLCHAIN_PREFIX && \
    ./install-wrappers.sh $TOOLCHAIN_PREFIX && \
    MINGW_W64_VERSION=aa08f56da559016f10336dddca85d59f9bdc9e02 ./build-mingw-w64.sh $TOOLCHAIN_PREFIX --with-default-msvcrt=$DEFAULT_CRT --with-default-win32-winnt=0xA00 && \
    ./build-mingw-w64-tools.sh $TOOLCHAIN_PREFIX && \
    ./build-compiler-rt.sh $TOOLCHAIN_PREFIX && \
    ./build-mingw-w64-libraries.sh $TOOLCHAIN_PREFIX && \
    ./build-libcxx.sh $TOOLCHAIN_PREFIX && \
    ./build-compiler-rt.sh $TOOLCHAIN_PREFIX --build-sanitizers && \
    rm -rf /build/* && \
    rm -rf /root/.wine /tmp/.wine-*

# Build libssp
COPY build-libssp.sh libssp-Makefile ./
RUN ./build-libssp.sh $TOOLCHAIN_PREFIX && \
    rm -rf /build/*

# Prepare wine installation
COPY scripts/wait_process.sh /opt/wine/
RUN chmod +x /opt/wine/wait_process.sh && \
    wget -q https://raw.githubusercontent.com/Winetricks/winetricks/5028127369b7b23b03789aec083ba5b68aa1ec34/src/winetricks -O /opt/wine/winetricks && \
    WINETRICKS_SHA256=7ec9c3e9140e592ef575140417f27e75e16ccebfeee9816cdbab21aa3d5c0841 && \
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
    rm -rf /tmp/.wine-*

ENV PATH=$TOOLCHAIN_PREFIX/bin:$PATH

COPY crossfiles /opt/crossfiles
