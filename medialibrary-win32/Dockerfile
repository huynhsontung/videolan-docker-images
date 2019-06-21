FROM registry.videolan.org:5000/vlc-debian-llvm-mingw:20190621125349

ENV IMAGE_DATE=201906211545

USER root
RUN mkdir -p /build && chown videolan /build && \
    mkdir -p /prefix && chown videolan /prefix
USER videolan

RUN TARGET_TRIPLE=i686-w64-mingw32 \
    SQLITE_VERSION=sqlite-autoconf-3260000 \
    SQLITE_SHA256=5daa6a3fb7d1e8c767cd59c4ded8da6e4b00c61d3b466d0685e35c4dd6d7bf5d \
    JPEGTURBO_VERSION=1.5.0 \
    JPEGTURBO_SHA256=9f397c31a67d2b00ee37597da25898b03eb282ccd87b135a50a69993b6a2035f \
    RAPIDJSON_VERSION=1.1.0 \
    RAPIDJSON_SHA256=bf7ced29704a1e696fbccf2a2b4ea068e7774fa37f6d7dd4039d0787f8bed98e && \
    mkdir -p /build && cd /build && \
    git clone --depth=1 https://git.videolan.org/git/vlc.git && \
    cd vlc && \
    cd extras/tools && ./bootstrap && make -j`nproc` && \
    export PATH=`pwd`/build/bin:$PATH && cd ../../ && \
    cd contrib && mkdir win32 && cd win32 && \
    ../bootstrap --host=$TARGET_TRIPLE --disable-qt --disable-skins2 \
        --disable-lua --disable-protobuf --disable-gettext \
        --disable-qtdeclarative --disable-qtgraphicaleffects --disable-qtquickcontrols \
        --disable-qtquickcontrols2 --disable-qtsvg && \
        make -j`nproc` && \
    cd /build/vlc && ./bootstrap && mkdir build && cd build && \
    ../configure --host=$TARGET_TRIPLE \
        --disable-lua --disable-qt --disable-skins2 \
        --disable-nls --disable-aom \
        --prefix=/prefix && \
    make -j`nproc` && make install && \
    mkdir -p /prefix/dll && \
    cp src/.libs/libvlccore.dll /prefix/dll/ && \
    cp lib/.libs/libvlc.dll /prefix/dll && \
    cd /build && wget -q https://www.sqlite.org/2018/$SQLITE_VERSION.tar.gz && \
    echo $SQLITE_SHA256 $SQLITE_VERSION.tar.gz | sha256sum -c && \
    tar xzf $SQLITE_VERSION.tar.gz && cd $SQLITE_VERSION && \
    ./configure --prefix=/prefix --host=$TARGET_TRIPLE --disable-shared && \
    make -j`nproc` && make install && \
    cd /build && \
    wget -q https://downloads.sourceforge.net/project/libjpeg-turbo/1.5.0/libjpeg-turbo-$JPEGTURBO_VERSION.tar.gz && \
    echo $JPEGTURBO_SHA256 libjpeg-turbo-$JPEGTURBO_VERSION.tar.gz | sha256sum -c && \
    tar xzf libjpeg-turbo-$JPEGTURBO_VERSION.tar.gz && \
    cd libjpeg-turbo-$JPEGTURBO_VERSION && ./configure --host=$TARGET_TRIPLE --prefix=/prefix --disable-shared && \
    make -j`nproc` && make install && \
    cd /build && wget -q https://github.com/miloyip/rapidjson/archive/v$RAPIDJSON_VERSION.tar.gz && \
    echo $RAPIDJSON_SHA256 v$RAPIDJSON_VERSION.tar.gz | sha256sum -c && \
    tar xzf v1.1.0.tar.gz && cd rapidjson-1.1.0/ && \
    cmake -DCMAKE_INSTALL_PREFIX=/prefix -DRAPIDJSON_BUILD_DOC=OFF \
        -DRAPIDJSON_BUILD_EXAMPLES=OFF -DRAPIDJSON_BUILD_TESTS=OFF . && \
    make install && \
    rm -rf /build

