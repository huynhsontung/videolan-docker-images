FROM debian:buster-20200224

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=202023031031

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

RUN addgroup --quiet --gid ${VIDEOLAN_CI_UID} videolan && \
    adduser --quiet --uid ${VIDEOLAN_CI_UID} --ingroup videolan videolan && \
    echo "videolan:videolan" | chpasswd && \
    apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends -y \
    ca-certificates autoconf m4 automake ant autopoint bison \
    flex build-essential libtool libtool-bin patch pkg-config ragel subversion \
    git yasm ragel g++ protobuf-compiler gettext meson ninja-build \
    wget expect unzip python python3 locales libltdl-dev curl cmake automake nasm && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    echo "export ANDROID_NDK=${ANDROID_NDK}" >> /etc/profile.d/vlc_env.sh && \
    echo "export ANDROID_SDK=${ANDROID_SDK}" >> /etc/profile.d/vlc_env.sh && \
    mkdir sdk && cd sdk && \
    ANDROID_NDK_VERSION=21 && \
    ANDROID_NDK_SHA256=b65ea2d5c5b68fb603626adcbcea6e4d12c68eb8a73e373bbb9d23c252fc647b && \
    wget -q https://dl.google.com/android/repository/android-ndk-r$ANDROID_NDK_VERSION-linux-x86_64.zip && \
    echo $ANDROID_NDK_SHA256 android-ndk-r$ANDROID_NDK_VERSION-linux-x86_64.zip | sha256sum -c && \
    unzip android-ndk-r$ANDROID_NDK_VERSION-linux-x86_64.zip && \
    rm -f android-ndk-r$ANDROID_NDK_VERSION-linux-x86_64.zip && \
    ln -s android-ndk-r$ANDROID_NDK_VERSION android-ndk && \
    mkdir android-sdk-linux && \
    cd android-sdk-linux && \
    mkdir "licenses" && \
    echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "licenses/android-sdk-license" && \
    echo "d56f5187479451eabf01fb78af6dfcb131a6481e" >> "licenses/android-sdk-license" && \
    echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" >> "licenses/android-sdk-license" && \
    wget -q https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
    SDK_TOOLS_SHA256=444e22ce8ca0f67353bda4b85175ed3731cae3ffa695ca18119cbacef1c1bea0 && \
    echo $SDK_TOOLS_SHA256 sdk-tools-linux-3859397.zip | sha256sum -c && \
    unzip sdk-tools-linux-3859397.zip && \
    rm -f sdk-tools-linux-3859397.zip && \
    cd / && \
    wget -q https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u232-b09/OpenJDK8U-jdk_x64_linux_8u232b09.tar.gz && \
    JDK_SHA256=c261f5e2776f4430249fcf6276649969a40f28262d1f224390aa764ae84464df && \
    echo $JDK_SHA256 OpenJDK8U-jdk_x64_linux_8u232b09.tar.gz | sha256sum -c && \
    mkdir -p /usr/lib/jvm/java-8-openjdk-amd64 && \
    tar -C /usr/lib/jvm/java-8-openjdk-amd64 -xvzf OpenJDK8U-jdk_x64_linux_8u232b09.tar.gz --strip=1 && \
    rm -f OpenJDK8U-jdk_x64_linux_8u232b09.tar.gz && \
    cd sdk/android-sdk-linux && \
    tools/bin/sdkmanager "build-tools;26.0.1" "platform-tools" "platforms;android-26" && \
    chown -R videolan /sdk && \
    mkdir /build && cd /build && \
    CMAKE_VERSION=3.17.0 && \
    CMAKE_SHA256=b74c05b55115eacc4fa2b77a814981dbda05cdc95a53e279fe16b7b272f00847 && \
    wget -q http://www.cmake.org/files/v3.17/cmake-$CMAKE_VERSION.tar.gz && \
    echo $CMAKE_SHA256 cmake-$CMAKE_VERSION.tar.gz | sha256sum -c && \
    tar xzf cmake-$CMAKE_VERSION.tar.gz && \
    cd cmake-$CMAKE_VERSION && ./configure --prefix=/opt/tools/ --parallel=$CORES --no-qt-gui -- \
        -DCMAKE_USE_OPENSSL:BOOL=OFF -DBUILD_TESTING:BOOL=OFF && make -j$CORES && make install && \
    rm -rf /build

ENV LANG en_US.UTF-8
USER videolan

RUN git config --global user.name "VLC Android" && \
    git config --global user.email buildbot@videolan.org
