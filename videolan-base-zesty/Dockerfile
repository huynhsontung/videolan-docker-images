FROM ubuntu:zesty

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=201707021640

RUN apt-get update && \
    apt-get install -y openssh-server openjdk-8-jdk lftp ca-certificates && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    sed -i 's,use_authtok ,,' /etc/pam.d/common-password && \
    ssh-keygen -A && \
    mkdir -p /var/run/sshd && \
    adduser --quiet jenkins && \
    echo "jenkins:jenkins" | chpasswd
