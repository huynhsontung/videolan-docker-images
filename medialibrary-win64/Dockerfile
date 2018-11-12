FROM registry.videolan.org:5000/vlc-debian-llvm-mingw:20181005113629

ENV IMAGE_DATE=201811121731

RUN TARGET_TRIPLE=x86_64-w64-mingw32 \
    SQLITE_VERSION=sqlite-autoconf-3140000 \
    SQLITE_SHA256=742db0ebbd9cc91ed6a41857f50aa9795fc859c994a256125135cd07f6cdfd76 \
    JPEGTURBO_VERSION=1.5.0 \
    JPEGTURBO_SHA256=9f397c31a67d2b00ee37597da25898b03eb282ccd87b135a50a69993b6a2035f \
    RAPIDJSON_VERSION=1.0.2 \
    RAPIDJSON_SHA256=c3711ed2b3c76a5565ee9f0128bb4ec6753dbcc23450b713842df8f236d08666 && \
    mkdir -p /build && cd /build && \
    git clone --depth=1 https://git.videolan.org/git/vlc.git && \
    cd vlc && \
    cd extras/tools && ./bootstrap && make -j`nproc` && \
    export PATH=`pwd`/build/bin:$PATH && cd ../../ && \
    cd contrib && mkdir win64 && cd win64 && \
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
    cd /build && wget -q https://www.sqlite.org/2016/$SQLITE_VERSION.tar.gz && \
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
    tar xzf v1.0.2.tar.gz && cd rapidjson-1.0.2/ && \
    cmake -DCMAKE_INSTALL_PREFIX=/prefix -DRAPIDJSON_BUILD_DOC=OFF \
        -DRAPIDJSON_BUILD_EXAMPLES=OFF -DRAPIDJSON_BUILD_TESTS=OFF . && \
    make install && \
    rm -rf /build

