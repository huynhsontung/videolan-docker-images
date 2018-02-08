FROM ubuntu:xenial-20151218.1

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=20180202081150

RUN sed -i 's,^\(deb.*updates.*\)$,#\1,g' /etc/apt/sources.list && \
    apt-get update && apt-get -y upgrade && \
    apt-get install -y openssh-server openjdk-8-jdk lftp ca-certificates && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    sed -i 's,use_authtok ,,' /etc/pam.d/common-password && \
    ssh-keygen -A && \
    mkdir -p /var/run/sshd && \
    adduser --quiet jenkins && \
    echo "jenkins:jenkins" | chpasswd
