FROM registry.videolan.org/vlc-debian-unstable:20190416182140

ENV IMAGE_DATE=201910281207

USER root

RUN apt-get update && apt-get install -yq --no-install-suggests --no-install-recommends \
    rapidjson-dev libsqlite3-dev lcov && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    mkdir -p /build/ && cd /build/ && \
    git clone https://git.videolan.org/git/vlc.git && \
    cd vlc && ./bootstrap && mkdir build && cd build && \
    LDFLAGS="-ltsan" \
    CFLAGS="-g -O0 -fno-omit-frame-pointer" \
    CXXFLAGS="-g -O0 -fno-omit-frame-pointer" \
    ../configure --disable-lua --disable-qt --disable-skins2 \
        --disable-nls \
        --with-sanitizer=thread \
        --disable-medialibrary \
        --prefix=/prefix && \
    make -j4 && make install && \
    git clone https://code.videolan.org/videolan/libvlcpp.git && \
    cd libvlcpp && ./bootstrap && \
    ./configure --prefix=/prefix/ && \
    make -j4 && make install && \
    rm -rf /build/

USER videolan
