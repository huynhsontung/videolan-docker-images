FROM registry.videolan.org:5000/vlc-debian-unstable:20181128113529

ENV IMAGE_DATE=201901211006

RUN apt-get update && apt-get install -yq \
    rapidjson-dev libsqlite3-dev lcov && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    cd / && \
    git clone https://git.videolan.org/git/vlc/vlc-3.0.git && \
    cd vlc-3.0 && ./bootstrap && mkdir build && cd build && \
    ../configure --disable-lua --disable-qt --disable-skins2 \
        --disable-nls \
        --prefix=/prefix && \
    make -j4 && make install && \
    git clone https://code.videolan.org/videolan/libvlcpp.git && \
    cd libvlcpp && ./bootstrap && \
    ./configure --prefix=/prefix/ && \
    make -j4 && make install

ENV PKG_CONFIG_PATH=/prefix/lib/pkgconfig 

