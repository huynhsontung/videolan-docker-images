FROM registry.videolan.org:5000/vlc-debian-win32:latest

ENV IMAGE_DATE=201612191143

ENV TARGET_TRIPLE=i686-w64-mingw32
ENV SQLITE_VERSION=sqlite-autoconf-3140000
ENV JPEGTURBO_VERSION=1.5.0

RUN mkdir /build && cd /build && \
    git clone https://git.videolan.org/git/vlc.git && \
    cd vlc && \
    cd contrib && mkdir win32 && cd win32 && \
    ../bootstrap --host=$TARGET_TRIPLE --disable-qt --disable-skins2 \
        --disable-lua --disable-protobuf --disable-gettext && make -j`nproc` && \
    cd /build/vlc && ./bootstrap && mkdir build && cd build && \
    ../configure --host=$TARGET_TRIPLE \
        --disable-lua --disable-qt --disable-skins2 \
        --disable-nls \
        --prefix=/prefix && \
    make -j`nproc` && make install && \
    mkdir -p /prefix/dll && \
    cp src/.libs/libvlccore.dll /prefix/dll/ && \
    cp lib/.libs/libvlc.dll /prefix/dll && \
    cd /build && wget https://www.sqlite.org/2016/$SQLITE_VERSION.tar.gz && \
    tar xzf $SQLITE_VERSION.tar.gz && cd $SQLITE_VERSION && \
    ./configure --prefix=/prefix --host=$TARGET_TRIPLE --disable-shared && \
    make -j`nproc` && make install && \
    cd /build && \
    wget http://downloads.sourceforge.net/project/libjpeg-turbo/1.5.0/libjpeg-turbo-$JPEGTURBO_VERSION.tar.gz && \
    tar xzf libjpeg-turbo-$JPEGTURBO_VERSION.tar.gz && \
    cd libjpeg-turbo-$JPEGTURBO_VERSION && ./configure --host=$TARGET_TRIPLE --prefix=/prefix --disable-shared && \
    make -j`nproc` && make install && \
    cd /build && wget https://github.com/miloyip/rapidjson/archive/v1.0.2.tar.gz && \
    tar xzf v1.0.2.tar.gz && cd rapidjson-1.0.2/ && \
    cmake -DCMAKE_INSTALL_PREFIX=/prefix -DRAPIDJSON_BUILD_DOC=OFF \
        -DRAPIDJSON_BUILD_EXAMPLES=OFF -DRAPIDJSON_BUILD_TESTS=OFF . && \
    make install && \
    rm -rf /build

