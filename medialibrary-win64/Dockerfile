FROM registry.videolan.org/vlc-debian-llvm-msvcrt:20221023173315

ENV IMAGE_DATE=202212140826

USER root

RUN mkdir -p /build/ml && chown videolan /build && chown videolan /build/ml && \
    mkdir -p /prefix && chown videolan /prefix

USER videolan

RUN export TARGET_TRIPLE=x86_64-w64-mingw32 && \
    SQLITE_VERSION=sqlite-autoconf-3340100 && \
    SQLITE_SHA256=2a3bca581117b3b88e5361d0ef3803ba6d8da604b1c1a47d902ef785c1b53e89 && \
    JPEGTURBO_VERSION=2.0.8-esr && \
    JPEGTURBO_SHA256=e536592f8729d1f16c2523c09c3753a64bb8870c75f73ce4451c84a55c5d9852 && \
    RAPIDJSON_VERSION=1.1.0 && \
    RAPIDJSON_SHA256=bf7ced29704a1e696fbccf2a2b4ea068e7774fa37f6d7dd4039d0787f8bed98e && \
    cd /build/ml && \
    git clone --depth=1000 https://code.videolan.org/videolan/vlc.git && \
    cd vlc && \
    export VLC_CONTRIB_SHA="$(extras/ci/get-contrib-sha.sh)" && \
    export VLC_PREBUILT_CONTRIBS_URL="https://artifacts.videolan.org/vlc/win64-llvm/vlc-contrib-${TARGET_TRIPLE}-${VLC_CONTRIB_SHA}.tar.bz2" && \
    CONFIGFLAGS="--prefix /prefix" ./extras/package/win32/build.sh -z -l -p -a x86_64 && \
    make -C win64 -j`nproc` package-win-common && \
    find /prefix/lib -name '*.la' -delete || echo "no .la files" && \
    mkdir -p /prefix/dll && \
    cp win64/src/.libs/libvlccore.dll /prefix/dll/ && \
    cp win64/lib/.libs/libvlc.dll /prefix/dll && \
    cd /build/ml && wget -q https://www.sqlite.org/2021/$SQLITE_VERSION.tar.gz && \
    echo $SQLITE_SHA256 $SQLITE_VERSION.tar.gz | sha256sum -c && \
    tar xzf $SQLITE_VERSION.tar.gz && cd $SQLITE_VERSION && \
    ./configure --prefix=/prefix --host=$TARGET_TRIPLE --disable-shared && \
    make -j`nproc` && make install && \
    cd /build/ml && \
    wget -q https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/$JPEGTURBO_VERSION.tar.gz && \
    echo $JPEGTURBO_SHA256 $JPEGTURBO_VERSION.tar.gz | sha256sum -c && \
    tar xzf $JPEGTURBO_VERSION.tar.gz && \
    cd libjpeg-turbo-$JPEGTURBO_VERSION && \
    cmake -DCMAKE_INSTALL_PREFIX=/prefix  -D_CMAKE_TOOLCHAIN_PREFIX=${TARGET_TRIPLE} \
        -DENABLE_SHARED=OFF -DWITH_TURBOJPEG=OFF . && \
    cmake --build . --parallel `nproc` && cmake --install . --prefix /prefix && \
    cd /build/ml && wget -q https://github.com/miloyip/rapidjson/archive/v$RAPIDJSON_VERSION.tar.gz && \
    echo $RAPIDJSON_SHA256 v$RAPIDJSON_VERSION.tar.gz | sha256sum -c && \
    tar xzf v$RAPIDJSON_VERSION.tar.gz && cd rapidjson-$RAPIDJSON_VERSION/ && \
    cmake -DCMAKE_INSTALL_PREFIX=/prefix -DRAPIDJSON_BUILD_DOC=OFF \
        -DRAPIDJSON_BUILD_EXAMPLES=OFF -DRAPIDJSON_BUILD_TESTS=OFF . && \
    cmake --build . --parallel `nproc` && cmake --install . --prefix /prefix && \
    rm -rf /build/ml

COPY crossfiles /opt/crossfiles
