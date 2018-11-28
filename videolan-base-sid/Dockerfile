FROM debian:sid-20181112-slim

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=201811281100

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the jenkins user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG JENKINS_UID=499

RUN echo "deb http://ftp.fr.debian.org/debian/ sid main" > /etc/apt/sources.list && \
    echo "deb-src http://ftp.fr.debian.org/debian/ sid main" >> /etc/apt/sources.list && \
    apt-get update && \
    mkdir -p /usr/share/man/man1 && \
    apt-get install -y openssh-server openjdk-8-jdk lftp ca-certificates curl && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    addgroup --quiet --gid ${JENKINS_UID} jenkins && \
    adduser --quiet --uid ${JENKINS_UID} --ingroup jenkins jenkins && \
    echo "jenkins:jenkins" | chpasswd

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
