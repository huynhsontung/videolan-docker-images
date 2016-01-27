FROM debian:sid

RUN apt-get update && apt-get -y install \
	ca-certificates build-essential \
	git-core automake libtool pkg-config autoconf \
	&& apt-get clean

RUN apt-get -y install libdvdread-dev

RUN git clone https://code.videolan.org/videolan/libdvdnav.git && \
	cd libdvdnav && \
	autoreconf -fisv && \
	./configure && \
	make


	
	
