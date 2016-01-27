FROM debian:jessie

RUN apt-get update && apt-get -y install \
	ca-certificates build-essential \
	git-core automake libtool pkg-config autoconf \
	&& apt-get clean

RUN apt-get -y install libvlc-dev libx11-xcb-dev iceweasel-dev

RUN apt-get -y install libgtk2.0-dev

RUN git clone https://code.videolan.org/videolan/npapi-vlc.git && \
	cd npapi-vlc && \
	git submodule update --init && \
	./autogen.sh && \
	./configure && \
	make


	
	
