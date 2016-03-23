FROM debian:sid

MAINTAINER VideoLAN roots <roots@videolan.org>

# Install and configure a basic SSH server
RUN apt-get update &&\
    apt-get install -y openssh-server &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd &&\
    mkdir -p /var/run/sshd

# Install JDK 7 (latest edition)
RUN apt-get update &&\
    apt-get install -y openjdk-7-jdk &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Set user jenkins to the image
RUN adduser --quiet jenkins && \
    echo "jenkins:jenkins" | chpasswd

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

COPY enforce-static.sh /

RUN apt-get update && apt-get -y install gcc-mingw-w64-i686 g++-mingw-w64-i686 mingw-w64-tools lua5.2-dev lua5.2 libtool automake autoconf autopoint make gettext pkg-config qt4-dev-tools qt4-default git subversion cmake cvs libwine-dev wine-development wine zip nsis bzip2 p7zip-full

RUN /enforce-static.sh
