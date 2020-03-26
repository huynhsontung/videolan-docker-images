FROM registry.videolan.org/vlc-debian-unstable:20191204094457

ENV IMAGE_DATE=202003261623

USER root

RUN apt-get update && apt-get install -yq --no-install-suggests --no-install-recommends \
    rapidjson-dev libsqlite3-dev lcov && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    cd / && \
    git clone https://git.videolan.org/git/vlc/vlc-3.0.git && \
    cd vlc-3.0 && \
    git config --global user.name 'VideoLAN CI' && \
    git config --global user.email 'root@videolan.org' && \
    mkdir contrib/native && cd contrib/native && \
    ../bootstrap && make .dvdread .dvdnav -j4 && \
    cd ../.. && \
    ./bootstrap && mkdir build && cd build && \
    ../configure --disable-lua --disable-qt --disable-skins2 \
        --disable-nls \
        --prefix=/prefix && \
    make -j4 && make install && \
    git clone https://code.videolan.org/videolan/libvlcpp.git && \
    cd libvlcpp && ./bootstrap && \
    ./configure --prefix=/prefix/ && \
    make -j4 && make install

ENV PKG_CONFIG_PATH=/prefix/lib/pkgconfig 

USER videolan
