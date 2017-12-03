FROM registry.videolan.org:5000/videolan-base-xenial:latest

ENV IMAGE_DATE=201712031330

# Don't clean the package lists cache, snapcraft needs it.
RUN apt-get update && \
    apt-get install -y git-core make build-essential snapcraft locales \
    qtbase5-private-dev wayland-protocols dh-buildinfo liblircclient-dev \
    libmodplug-dev libdirectfb-dev libqt5svg5-dev flex bison && \
    apt-get build-dep -y vlc && \
    apt-get clean -y && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8
