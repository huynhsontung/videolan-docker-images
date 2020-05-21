FROM ubuntu:eoan-20200410

ENV IMAGE_DATE=202005211240

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the videolan user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG VIDEOLAN_UID=499

ENV SHADERC_BRANCH=v2020.0 \
    GLSLANG_BRANCH=8.13.3743 \
    SPIRV_TOOLS_BRANCH=v2020.2 \
    SPIRV_HEADERS_COMMIT=c0df742ec0b8178ad58c68cff3437ad4b6a06e26

RUN set -x && \
    addgroup --quiet --gid ${VIDEOLAN_UID} videolan && \
    adduser --quiet --uid ${VIDEOLAN_UID} --ingroup videolan videolan && \
    usermod --append --groups video videolan && \
    echo "videolan:videolan" | chpasswd && \
    apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends -y \
        git-core build-essential cmake clang clang-tools lcov \
        python python3-pip python3-setuptools python3-wheel \
        gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 gcc-mingw-w64-i686 \
        g++-mingw-w64-i686 mingw-w64-tools glslang-dev libvulkan-dev \
        vulkan-validationlayers mesa-vulkan-drivers vulkan-tools \
        liblcms2-dev libepoxy-dev python3-mako gdb systemd-coredump && \
    pip3 install meson ninja gcovr && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    cd /root && \
    git clone --depth 1 -b ${SHADERC_BRANCH}         https://github.com/google/shaderc && \
    cd shaderc && \
    git clone --depth 1 -b ${GLSLANG_BRANCH}         https://github.com/KhronosGroup/glslang.git         third_party/glslang && \
    git clone --depth 1 -b ${SPIRV_TOOLS_BRANCH}     https://github.com/KhronosGroup/SPIRV-Tools.git     third_party/spirv-tools && \
    git clone https://github.com/KhronosGroup/SPIRV-Headers.git third_party/spirv-headers && \
    cd third_party/spirv-headers && git checkout ${SPIRV_HEADERS_COMMIT} && cd ../.. && \
    mkdir build && cd build && \
    cmake -GNinja \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DSHADERC_SKIP_TESTS=1 \
        .. && \
    ninja && \
    cp -a libshaderc*/libshaderc*.a   /usr/local/lib && \
    cp -a libshaderc*/libshaderc*.so* /usr/local/lib && \
    cp -a ../libshaderc*/include /usr/local && \
    ldconfig && \
    cd /root && \
    rm -rf shaderc

COPY crossfiles/ /opt/crossfiles/

USER videolan
