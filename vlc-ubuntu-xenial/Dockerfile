FROM registry.videolan.org:5000/videolan-base-xenial:latest

ENV IMAGE_DATE=201802071245

# Don't clean the package lists cache, snapcraft needs it.
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
    apt-get clean -y && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8
