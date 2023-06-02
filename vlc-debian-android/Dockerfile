FROM debian:bookworm-20230522-slim

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=202306021100

COPY crossfiles/ /opt/crossfiles/

ENV ANDROID_NDK="/sdk/android-ndk" \
    ANDROID_SDK="/sdk/android-sdk-linux"

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the videolan user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG VIDEOLAN_CI_UID=499

ARG CORES=8

ENV PATH=/usr/lib/jvm/java-8-openjdk-amd64/bin:/sdk/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/bin/:/opt/tools/bin:$PATH

RUN groupadd --gid ${VIDEOLAN_CI_UID} videolan && \
    useradd --uid ${VIDEOLAN_CI_UID} --gid videolan --create-home --shell /bin/bash videolan && \
    echo "videolan:videolan" | chpasswd && \
    mkdir -p /usr/share/man/man1 && \
    apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends -y \
        ca-certificates autoconf m4 automake ant autopoint bison \
        flex build-essential libtool libtool-bin patch pkg-config ragel subversion cmake meson \
        git yasm ragel g++ protobuf-compiler gettext ninja-build \
        wget expect unzip python3 python3-venv python3-setuptools python3-mako \
        locales libltdl-dev curl automake nasm && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    echo "export ANDROID_NDK=${ANDROID_NDK}" >> /etc/profile.d/vlc_env.sh && \
    echo "export ANDROID_SDK=${ANDROID_SDK}" >> /etc/profile.d/vlc_env.sh && \
    mkdir sdk && cd sdk && \
    ANDROID_NDK_VERSION=25c && \
    ANDROID_NDK_SHA256=769ee342ea75f80619d985c2da990c48b3d8eaf45f48783a2d48870d04b46108 && \
    wget -q https://dl.google.com/android/repository/android-ndk-r$ANDROID_NDK_VERSION-linux.zip && \
    echo $ANDROID_NDK_SHA256 android-ndk-r$ANDROID_NDK_VERSION-linux.zip | sha256sum -c && \
    unzip android-ndk-r$ANDROID_NDK_VERSION-linux.zip && \
    rm -f android-ndk-r$ANDROID_NDK_VERSION-linux.zip && \
    ln -s android-ndk-r$ANDROID_NDK_VERSION android-ndk && \
    mkdir android-sdk-linux && \
    cd android-sdk-linux && \
    mkdir "licenses" && \
    echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "licenses/android-sdk-license" && \
    echo "d56f5187479451eabf01fb78af6dfcb131a6481e" >> "licenses/android-sdk-license" && \
    echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" >> "licenses/android-sdk-license" && \
    SDK_TOOLS_FILENAME=commandlinetools-linux-7583922_latest.zip && \
    wget -q https://dl.google.com/android/repository/$SDK_TOOLS_FILENAME && \
    SDK_TOOLS_SHA256=124f2d5115eee365df6cf3228ffbca6fc3911d16f8025bebd5b1c6e2fcfa7faf && \
    echo $SDK_TOOLS_SHA256 $SDK_TOOLS_FILENAME | sha256sum -c && \
    unzip $SDK_TOOLS_FILENAME && \
    rm -f $SDK_TOOLS_FILENAME && \
    cd / && \
    JDK_FILENAME=OpenJDK11U-jdk_x64_linux_11.0.12_7.tar.gz && \
    wget -q https://github.com/AdoptOpenJDK/openjdk11-upstream-binaries/releases/download/jdk-11.0.12%2B7/$JDK_FILENAME && \
    JDK_SHA256=06c04b1eccd61dec3849e88f7606d17192c9a713a433ba26f82fe5fe9587d6bb && \
    echo $JDK_SHA256 $JDK_FILENAME | sha256sum -c && \
    mkdir -p /usr/lib/jvm/java-8-openjdk-amd64 && \
    tar -C /usr/lib/jvm/java-8-openjdk-amd64 -xvzf $JDK_FILENAME --strip=1 && \
    rm -f $JDK_FILENAME && \
    cd sdk/android-sdk-linux && \
    cmdline-tools/bin/sdkmanager --sdk_root=/sdk/android-sdk-linux/ "build-tools;26.0.1" "platform-tools" "platforms;android-26" && \
    chown -R videolan /sdk && \
    mkdir /build && cd /build && \
    PROTOBUF_VERSION=3.4.1 && \
    PROTOBUF_SHA256=2bb34b4a8211a30d12ef29fd8660995023d119c99fbab2e5fe46f17528c9cc78 && \
    wget -q https://github.com/google/protobuf/releases/download/v$PROTOBUF_VERSION/protobuf-cpp-$PROTOBUF_VERSION.tar.gz && \
    echo $PROTOBUF_SHA256 protobuf-cpp-$PROTOBUF_VERSION.tar.gz | sha256sum -c && \
    tar xzfo protobuf-cpp-$PROTOBUF_VERSION.tar.gz && \
    cd protobuf-$PROTOBUF_VERSION && \
# force include <algorithm> \
    sed -i.orig 's,#ifdef _MSC_VER,#if 1,' "src/google/protobuf/repeated_field.h" && \
    cmake  -S cmake -B build -DBUILD_SHARED_LIBS=OFF -Dprotobuf_BUILD_TESTS=OFF -Dprotobuf_BUILD_EXAMPLES=OFF && \
    cmake --build build --parallel $CORES && cmake --install build --prefix /opt/tools && \
    rm -rf /build

ENV LANG en_US.UTF-8
USER videolan

RUN git config --global user.name "VLC Android" && \
    git config --global user.email buildbot@videolan.org
