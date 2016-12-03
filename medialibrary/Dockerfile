FROM registry.videolan.org:5000/vlc-debian-unstable:latest

RUN apt-get update && apt-get install -yq \
    rapidjson-dev libsqlite3-dev && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN git clone https://git.videolan.org/git/vlc.git && \
    cd vlc && ./bootstrap && mkdir build && cd build && \
    ../configure --disable-lua --disable-qt --disable-skins2 \
        --disable-nls \
        --prefix=/prefix && \
    make -j4 && make install && \
    git clone https://code.videolan.org/videolan/libvlcpp.git && \
    cd libvlcpp && ./bootstrap && \
    ./configure --prefix=/prefix/ && \
    make -j4 && make install

ENV PKG_CONFIG_PATH=/prefix/lib/pkgconfig 

