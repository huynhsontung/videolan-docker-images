FROM videolan-base-jessie:latest

RUN apt-get update && apt-get -y install \
	ca-certificates build-essential git-core make && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*
