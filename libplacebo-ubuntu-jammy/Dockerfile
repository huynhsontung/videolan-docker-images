FROM ubuntu:jammy-20221130

ENV IMAGE_DATE=202301310000

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the videolan user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG VIDEOLAN_UID=499

ENV SDK_VERSION=1.3.236 \
    SPIRV_CROSS_BRANCH=sdk-1.3.236.0

COPY crossfiles/ /opt/crossfiles/

RUN set -x && \
    apt-get update && apt-get --no-install-suggests --no-install-recommends -y install udev && \
    ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
    addgroup --quiet --gid ${VIDEOLAN_UID} videolan && \
    adduser --quiet --uid ${VIDEOLAN_UID} --ingroup videolan videolan && \
    usermod --append --groups video,render videolan && \
    echo "videolan:videolan" | chpasswd && \
    apt-get install --no-install-suggests --no-install-recommends -y \
        apt-utils git-core build-essential gnupg clang clang-tools llvm gdb lcov \
        python3-pip python3-setuptools python3-wheel python3-mako \
        libepoxy-dev libgles1 libgles2 liblcms2-dev curl mesa-vulkan-drivers \
        libavcodec-dev libavdevice-dev libavfilter-dev libavformat-dev libavutil-dev \
        gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 gcc-mingw-w64-i686 \
        g++-mingw-w64-i686 mingw-w64-tools cmake wine systemd-coredump && \
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
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    cd /root && \
    git clone --depth 1 -b ${SPIRV_CROSS_BRANCH} https://github.com/KhronosGroup/SPIRV-Cross.git && \
    cd SPIRV-Cross && \
    cmake -H. -Bbuild64 -GNinja \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DCMAKE_TOOLCHAIN_FILE=/opt/crossfiles/x86_64-w64-mingw32.cmake \
        -DCMAKE_INSTALL_PREFIX=/usr/x86_64-w64-mingw32 \
        -DSPIRV_CROSS_SHARED=ON \
        -DSPIRV_CROSS_CLI=OFF \
        -DSPIRV_CROSS_ENABLE_TESTS=OFF \
        .. && \
    ninja -Cbuild64 install && \
    cmake -H. -Bbuild -GNinja \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DCMAKE_TOOLCHAIN_FILE=/opt/crossfiles/i686-w64-mingw32.cmake \
        -DCMAKE_INSTALL_PREFIX=/usr/i686-w64-mingw32 \
        -DSPIRV_CROSS_SHARED=ON \
        -DSPIRV_CROSS_CLI=OFF \
        -DSPIRV_CROSS_ENABLE_TESTS=OFF \
        .. && \
    ninja -Cbuild install && \
    cd /root && \
    echo rm -rf SPIRV-Cross

USER videolan
