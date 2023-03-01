FROM debian:bullseye-20230208-slim

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=202302281650

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
    apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends \
        make php-cgi php-curl php-gd php-intl php-mbstring php-json \
        php-opcache php-pgsql php-readline php-xml git ca-certificates sassc \
        gettext locales-all yui-compressor \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

USER videolan
