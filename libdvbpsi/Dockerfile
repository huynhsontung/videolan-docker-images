FROM videolan-base-jessie:latest

RUN apt-get update && apt-get -y install \
    ca-certificates build-essential git-core automake libtool pkg-config
    autoconf && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*
