FROM golangci/golangci-lint:v1.26-alpine

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=202005051145

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the videolan user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG VIDEOLAN_UID=499

RUN addgroup -g ${VIDEOLAN_UID} videolan && \
    adduser -u ${VIDEOLAN_UID} -G videolan -h /home/videolan -D videolan && \
    echo "videolan:videolan" | chpasswd && \
    apk --no-cache add build-base jq

USER videolan
