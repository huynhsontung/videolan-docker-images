FROM videolan-base-xenial:latest

# Don't clean the package lists cache, snapcraft needs it.
RUN apt-get update && \
    apt-get install -y git-core make build-essential snapcraft locales && \
    apt-get clean -y && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8

