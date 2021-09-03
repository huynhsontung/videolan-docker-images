FROM registry.videolan.org/vlc-debian-win32:20201106141924

ENV IMAGE_DATE=202102152105

USER root
RUN mkdir -p /build/ml && chown videolan /build && chown videolan /build/ml && \
    mkdir -p /prefix && chown videolan /prefix
USER videolan

RUN TARGET_TRIPLE=i686-w64-mingw32 \
    SQLITE_VERSION=sqlite-autoconf-3340100 \
    SQLITE_SHA256=2a3bca581117b3b88e5361d0ef3803ba6d8da604b1c1a47d902ef785c1b53e89 \
    JPEGTURBO_VERSION=1.5.0 \
    JPEGTURBO_SHA256=232280e1c9c3e6a1de95fe99be2f7f9c0362ee08f3e3e48d50ee83b9a2ed955b \
    RAPIDJSON_VERSION=1.1.0 \
    RAPIDJSON_SHA256=bf7ced29704a1e696fbccf2a2b4ea068e7774fa37f6d7dd4039d0787f8bed98e && \
    mkdir -p /build/ml && cd /build/ml && \
    git clone --depth=1 https://code.videolan.org/videolan/vlc.git && \
    cd vlc && \
    ./extras/package/win32/build.sh -z -a i686 -o /prefix/ && \
    find /prefix/lib -name '*.la' -delete && \
    mkdir -p /prefix/dll && \
    cp win32/src/.libs/libvlccore.dll /prefix/dll/ && \
    cp win32/lib/.libs/libvlc.dll /prefix/dll && \
    cd /build/ml && wget -q https://www.sqlite.org/2021/$SQLITE_VERSION.tar.gz && \
    echo $SQLITE_SHA256 $SQLITE_VERSION.tar.gz | sha256sum -c && \
    tar xzf $SQLITE_VERSION.tar.gz && cd $SQLITE_VERSION && \
    ./configure --prefix=/prefix --host=$TARGET_TRIPLE --disable-shared && \
    make -j`nproc` && make install && \
    cd /build/ml && \
    wget -q -O libjpeg-turbo-$JPEGTURBO_VERSION.tar.gz https://github.com/libjpeg-turbo/libjpeg-turbo/archive/$JPEGTURBO_VERSION.tar.gz && \
    echo $JPEGTURBO_SHA256 libjpeg-turbo-$JPEGTURBO_VERSION.tar.gz | sha256sum -c && \
    tar xzf libjpeg-turbo-$JPEGTURBO_VERSION.tar.gz && \
    cd libjpeg-turbo-$JPEGTURBO_VERSION && autoreconf -vif && ./configure --host=$TARGET_TRIPLE --prefix=/prefix --disable-shared && \
    make -j`nproc` && make install && \
    cd /build/ml && wget -q https://github.com/miloyip/rapidjson/archive/v$RAPIDJSON_VERSION.tar.gz && \
    echo $RAPIDJSON_SHA256 v$RAPIDJSON_VERSION.tar.gz | sha256sum -c && \
    tar xzf v1.1.0.tar.gz && cd rapidjson-1.1.0/ && \
    cmake -DCMAKE_INSTALL_PREFIX=/prefix -DRAPIDJSON_BUILD_DOC=OFF \
        -DRAPIDJSON_BUILD_EXAMPLES=OFF -DRAPIDJSON_BUILD_TESTS=OFF . && \
    make install && \
    rm -rf /build/ml

COPY crossfiles /opt/crossfiles
