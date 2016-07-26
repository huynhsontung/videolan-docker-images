FROM jenkins-vlc-devel-debian-unstable:latest

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

