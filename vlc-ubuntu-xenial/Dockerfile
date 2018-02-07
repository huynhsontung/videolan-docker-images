FROM registry.videolan.org:5000/videolan-base-xenial:latest

ENV IMAGE_DATE=201802080045

RUN apt-get update && \
    apt-get install -y git-core make build-essential snapcraft locales \
    qtbase5-private-dev wayland-protocols dh-buildinfo liblircclient-dev \
    libmodplug-dev libdirectfb-dev libqt5svg5-dev flex bison cmake cmake-data \
    libauthen-sasl-perl libcurl3 libencode-locale-perl libfile-listing-perl \
    libfont-afm-perl libhtml-form-perl libhtml-format-perl libhtml-parser-perl \
    libhtml-tagset-perl libhtml-tree-perl libhttp-cookies-perl libhttp-daemon-perl \
    libhttp-date-perl libhttp-message-perl libhttp-negotiate-perl libio-html-perl \
    libio-socket-ssl-perl libjsoncpp1 liblwp-mediatypes-perl \
    liblwp-protocol-https-perl libmailtools-perl libnet-http-perl \
    libnet-smtp-ssl-perl libnet-ssleay-perl libtext-unidecode-perl liburi-perl \
    libvpx-dev libwww-perl libwww-robotrules-perl libxml-libxml-perl \
    libxml-namespacesupport-perl libxml-parser-perl libxml-sax-base-perl \
    libxml-sax-expat-perl libxml-sax-perl tex-common texinfo yasm libgtk-3-dev \
    libprojectm-dev libsecret-1-dev protobuf-compiler protobuf-c-compiler && \
    apt-get build-dep -y vlc && \
    apt-get install --allow-downgrades -y \
               libmirclient9=0.21.0+16.04.20160330-0ubuntu1 \
               libmirclient-dev=0.21.0+16.04.20160330-0ubuntu1 \
               libmircommon-dev=0.21.0+16.04.20160330-0ubuntu1 \
               libmircookie-dev=0.21.0+16.04.20160330-0ubuntu1 \
               libmircookie2=0.21.0+16.04.20160330-0ubuntu1 \
               libwayland-egl1-mesa=11.2.0-1ubuntu2 \
               libegl1-mesa-dev=11.2.0-1ubuntu2 \
               libegl1-mesa=11.2.0-1ubuntu2 \
               libgl1-mesa-dri=11.2.0-1ubuntu2 \
               libegl1-mesa-dev=11.2.0-1ubuntu2 && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8
