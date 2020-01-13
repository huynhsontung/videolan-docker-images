FROM debian:buster-20190708

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=201912041800

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the videolan user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG VIDEOLAN_UID=499

RUN addgroup --quiet --gid ${VIDEOLAN_UID} videolan && \
    adduser --quiet --uid ${VIDEOLAN_UID} --ingroup videolan videolan && \
    usermod --append --groups video videolan && \
    echo "videolan:videolan" | chpasswd && \
    echo "deb http://ftp.fr.debian.org/debian/ buster main" > /etc/apt/sources.list && \
    echo "deb-src http://ftp.fr.debian.org/debian/ buster main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y make jekyll ruby-jekyll-sass-converter python3-sphinx && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

USER videolan
