FROM ubuntu:focal-20220531

ENV IMAGE_DATE=202206100000

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the videolan user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG VIDEOLAN_UID=499

# For updates check: https://packages.lunarg.com/
ENV SDK_VERSION=1.3.211

RUN set -x && \
    apt-get update && apt-get --no-install-suggests --no-install-recommends -y install udev && \
    ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
    addgroup --quiet --gid ${VIDEOLAN_UID} videolan && \
    adduser --quiet --uid ${VIDEOLAN_UID} --ingroup videolan videolan && \
    usermod --append --groups video,render videolan && \
    echo "videolan:videolan" | chpasswd && \
    apt-get install --no-install-suggests --no-install-recommends -y \
        apt-utils git-core build-essential gnupg clang clang-tools llvm gdb lcov \
        python python3-pip python3-setuptools python3-wheel python3-mako \
        libepoxy-dev liblcms2-dev curl mesa-vulkan-drivers \
        libavcodec-dev libavdevice-dev libavfilter-dev libavformat-dev libavutil-dev \
        gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 gcc-mingw-w64-i686 \
        g++-mingw-w64-i686 mingw-w64-tools wine systemd-coredump && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends -y wine32 && \
    pip3 install meson ninja gcovr && \
    curl -s https://packages.lunarg.com/lunarg-signing-key-pub.asc | apt-key add - && \
    echo "deb https://packages.lunarg.com/vulkan/${SDK_VERSION} focal main" > /etc/apt/sources.list.d/lunarg-vulkan-focal.list && \
    apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends -y \
        vulkan-headers libvulkan-dev vulkan-validationlayers \
        vulkan-tools lunarg-vulkan-layers glslang-dev shaderc && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

COPY crossfiles/ /opt/crossfiles/

USER videolan
