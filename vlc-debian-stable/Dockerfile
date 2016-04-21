FROM debian:jessie

MAINTAINER VideoLAN roots <roots@videolan.org>

RUN echo "deb http://ftp.fr.debian.org/debian/ jessie main" > /etc/apt/sources.list && \
    echo "deb-src http://ftp.fr.debian.org/debian/ jessie main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y openssh-server openjdk-7-jdk && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    adduser --quiet jenkins && \
    echo "jenkins:jenkins" | chpasswd && \
    apt-get build-dep -y vlc && \
    apt-get install git-core

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
