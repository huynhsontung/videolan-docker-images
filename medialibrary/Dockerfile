FROM registry.videolan.org/vlc-debian-unstable:20190416182140

ENV IMAGE_DATE=201905311703

USER root

RUN apt-get update && apt-get install -yq --no-install-suggests --no-install-recommends \
    rapidjson-dev libsqlite3-dev lcov vlc-plugin-base libvlc-dev && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

USER videolan
