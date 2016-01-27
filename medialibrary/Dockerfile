FROM debian:sid

RUN apt-get update && apt-get -y install \
	ca-certificates build-essential \
	git-core automake libtool pkg-config autoconf \
	&& apt-get clean

RUN apt-get -y install libvlc-dev libvlccore-dev cmake libjpeg-dev subversion rapidjson-dev libevas-dev libsqlite3-dev

RUN git clone https://code.videolan.org/videolan/medialibrary.git && \
	cd medialibrary && \
	git clone https://code.videolan.org/videolan/libvlcpp.git && \
	cmake -DLIBVLCPP_DIR=libvlcpp . && \
	make && \
	cd test && ./unittest


	
	
