FROM debian:sid

RUN apt-get update && apt-get -y install \
	ca-certificates build-essential \
	git-core automake libtool pkg-config autoconf \
	&& apt-get clean

RUN apt-get -y install libvlc-dev libvlccore-dev cmake

RUN git clone https://code.videolan.org/videolan/libvlcpp.git && \
	cd libvlcpp && \
	cmake . && \
	make


	
	
