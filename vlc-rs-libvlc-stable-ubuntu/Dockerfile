FROM ubuntu:focal-20211006

LABEL maintainer="VideoLAN roots <roots@videolan.org>"

ENV IMAGE_DATE=202111110933
ENV RUST_VERSION=1.56.1

ENV DEBIAN_FRONTEND=noninteractive
ENV RUST_HOME=/opt/rust

ENV DEBIAN_FRONTEND=noninteractive
ARG VIDEOLAN_UID=499

RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends pkg-config curl gcc ca-cacert libclang-dev && \
    apt-get install -y --no-install-recommends libvlc-dev libvlccore-dev && \
    addgroup --quiet --gid ${VIDEOLAN_UID} videolan && \
    adduser --quiet --uid ${VIDEOLAN_UID} --ingroup videolan videolan && \
    echo "videolan:videolan" | chpasswd && \
    mkdir $RUST_HOME && chown videolan $RUST_HOME

USER videolan

ENV RUSTUP_HOME=$RUST_HOME/rustup
ENV CARGO_HOME=$RUST_HOME/cargo

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain none -y && \
    . $CARGO_HOME/env && \
    rustup toolchain install $RUST_VERSION

ENV PATH=$CARGO_HOME/bin:$PATH
ENV RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"