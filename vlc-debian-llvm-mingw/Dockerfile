FROM registry.videolan.org:5000/videolan-base-sid:20181128112333
 
ENV IMAGE_DATE=201901211004

RUN apt-get update -qq && apt-get install -qqy \
    git wget bzip2 file unzip libtool pkg-config cmake build-essential \
    automake yasm gettext autopoint vim python git-svn ninja-build libwine-dev \
    wine flex ragel bison zip dos2unix p7zip-full subversion gperf nsis nasm \
    python3 locales meson && \
    dpkg --add-architecture i386 && \
    apt-get update && apt-get -y install wine32 && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.UTF-8

# Disable statx for the time being to fix Qt build
# https://bugreports.qt.io/browse/QTBUG-64490
RUN for f in /usr/include/sys/syscall.h /usr/include/$(gcc -print-multiarch)/sys/syscall.h; do \
    if [ -f $f ]; then \
      echo "#undef SYS_statx" >> $f; \
    fi; \
    done

RUN git config --global user.name "LLVM MinGW" && \
    git config --global user.email root@localhost

WORKDIR /build

ARG CORES=4

ENV TOOLCHAIN_PREFIX=/opt/llvm-mingw

# Build and strip the LLVM installation
COPY build-llvm.sh strip-llvm.sh ./
RUN ./build-llvm.sh $TOOLCHAIN_PREFIX && \
    ./strip-llvm.sh $TOOLCHAIN_PREFIX && \
    rm -rf /build/*

ARG TOOLCHAIN_ARCHS="i686 x86_64 armv7 aarch64"

# Install the usual $TUPLE-clang binaries
COPY wrappers/*.sh wrappers/*.c ./wrappers/
COPY install-wrappers.sh .
RUN ./install-wrappers.sh $TOOLCHAIN_PREFIX && \
    rm -rf /build/*

# Build MinGW-w64, compiler-rt and mingw-w64's extra libraries
COPY build-mingw-w64.sh build-compiler-rt.sh build-mingw-w64-libraries.sh ./
RUN ./build-mingw-w64.sh $TOOLCHAIN_PREFIX && \
    ./build-compiler-rt.sh $TOOLCHAIN_PREFIX && \
    ./build-mingw-w64-libraries.sh $TOOLCHAIN_PREFIX && \
    rm -rf /build/*

# Build libunwind/libcxxabi/libcxx
COPY build-libcxx.sh ./
RUN ./build-libcxx.sh $TOOLCHAIN_PREFIX && \
    rm -rf /build/*

# Build sanitizers
COPY build-compiler-rt.sh .
RUN ./build-compiler-rt.sh $TOOLCHAIN_PREFIX --build-sanitizers && \
    rm -rf /build/*

# Build libssp
COPY build-libssp.sh libssp-Makefile ./
RUN ./build-libssp.sh $TOOLCHAIN_PREFIX && \
    rm -rf /build/*

# Cheating: Pull strip and objcopy from the normal binutils package.
RUN apt-get update -qq && \
    apt-get install -qqy binutils-mingw-w64-x86-64 && \
    cp /usr/bin/x86_64-w64-mingw32-strip $TOOLCHAIN_PREFIX/bin/binutils-strip && \
    cp /usr/bin/x86_64-w64-mingw32-objcopy $TOOLCHAIN_PREFIX/bin/binutils-objcopy && \
    apt-get remove -qqy binutils-mingw-w64-x86-64 && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

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
    rm -rf ~/.cache/winetricks && \
    rm -rf /tmp/wine-*

USER root

ENV PATH=$TOOLCHAIN_PREFIX/bin:$PATH

COPY crossfiles /opt/crossfiles

