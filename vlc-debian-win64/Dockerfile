FROM videolan-base-sid:latest

COPY enforce-static.sh /

RUN apt-get update && apt-get -y install \
    gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 mingw-w64-tools lua5.2-dev \
    lua5.2 libtool automake autoconf autopoint make gettext pkg-config \
    qt4-dev-tools qt4-default git subversion cmake cvs libwine-dev \
    wine-development wine zip nsis bzip2 p7zip-full wget dos2unix ragel \
    yasm g++ protobuf-compiler m4 ant build-essential libtool-bin \
    gcc-mingw-w64-i686 g++-mingw-w64-i686 && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN /enforce-static.sh
