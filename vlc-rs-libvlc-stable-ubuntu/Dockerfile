FROM ubuntu:focal-20211006

LABEL maintainer="VideoLAN roots <roots@videolan.org>"

ENV IMAGE_DATE=202110210936
ENV DEBIAN_FRONTEND=noninteractive

ARG VIDEOLAN_UID=499

RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends pkg-config curl gcc ca-cacert libclang-dev && \
    apt-get install -y --no-install-recommends libvlc-dev libvlccore-dev && \
    addgroup --quiet --gid ${VIDEOLAN_UID} videolan && \
    adduser --quiet --uid ${VIDEOLAN_UID} --ingroup videolan videolan && \
    echo "videolan:videolan" | chpasswd

USER videolan

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain none -y && \
    . $HOME/.cargo/env && \
    rustup toolchain install 1.56.0

ENV PATH=$HOME/.cargo/bin:$PATH
    