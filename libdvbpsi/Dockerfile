FROM debian:8

RUN apt-get update && apt-get -y install \
	ca-certificates build-essential \
	git-core automake libtool pkg-config autoconf \
	&& apt-get clean

RUN git clone https://code.videolan.org/videolan/libdvbpsi.git && \
	cd libdvbpsi && \
	./bootstrap && \
	./configure && \
	make


	
	
