FROM debian:sid

MAINTAINER VideoLAN roots <roots@videolan.org>

# jenkins-specific part
RUN apt-get update && \
    apt-get install -y openssh-server && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd

RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN adduser --quiet jenkins && \
    echo "jenkins:jenkins" | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

# build-specific part
COPY enforce-static.sh /

RUN echo "deb http://ftp.fr.debian.org/debian/ sid main" > /etc/apt/sources.list

RUN apt-get update && apt-get -y install gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 mingw-w64-tools lua5.2-dev lua5.2 libtool automake autoconf autopoint make gettext pkg-config qt4-dev-tools qt4-default git subversion cmake cvs libwine-dev wine-development wine zip nsis bzip2 p7zip-full && apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN /enforce-static.sh
