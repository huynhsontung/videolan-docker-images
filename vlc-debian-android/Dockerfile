FROM debian:stretch-20190204

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=2019020131307

ENV ANDROID_NDK="/sdk/android-ndk" \
    ANDROID_SDK="/sdk/android-sdk-linux"

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the videolan user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG VIDEOLAN_CI_UID=499

RUN addgroup --quiet --gid ${VIDEOLAN_CI_UID} videolan && \
    adduser --quiet --uid ${VIDEOLAN_CI_UID} --ingroup videolan videolan && \
    echo "videolan:videolan" | chpasswd && \
    apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends -y \
    openjdk-8-jdk-headless ca-certificates autoconf m4 automake ant autopoint bison \
    flex build-essential libtool libtool-bin patch pkg-config ragel subversion \
    git rpm2cpio libwebkitgtk-1.0-0 yasm ragel g++ protobuf-compiler gettext \
    libgsm1-dev wget expect unzip python python3 locales libltdl-dev && \
    echo "deb http://ftp.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/stretch-backports.list && \
    apt-get update && apt-get -y -t stretch-backports install cmake && \
    rm -f /etc/apt/sources.list.d/stretch-backports.list && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    echo "export ANDROID_NDK=${ANDROID_NDK}" >> /etc/profile.d/vlc_env.sh && \
    echo "export ANDROID_SDK=${ANDROID_SDK}" >> /etc/profile.d/vlc_env.sh && \
    mkdir sdk && cd sdk && \
    wget -q https://dl.google.com/android/repository/android-ndk-r18b-linux-x86_64.zip && \
    ANDROID_NDK_SHA256=4f61cbe4bbf6406aa5ef2ae871def78010eed6271af72de83f8bd0b07a9fd3fd && \
    echo $ANDROID_NDK_SHA256 android-ndk-r18b-linux-x86_64.zip | sha256sum -c && \
    unzip android-ndk-r18b-linux-x86_64.zip && \
    rm -f android-ndk-r18b-linux-x86_64.zip && \
    ln -s android-ndk-r18b android-ndk && \
    mkdir android-sdk-linux && \
    cd android-sdk-linux && \
    mkdir "licenses" && \
    echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "licenses/android-sdk-license" && \
    echo "d56f5187479451eabf01fb78af6dfcb131a6481e" >> "licenses/android-sdk-license" && \
    wget -q https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
    SDK_TOOLS_SHA256=444e22ce8ca0f67353bda4b85175ed3731cae3ffa695ca18119cbacef1c1bea0 && \
    echo $SDK_TOOLS_SHA256 sdk-tools-linux-3859397.zip | sha256sum -c && \
    unzip sdk-tools-linux-3859397.zip && \
    rm -f sdk-tools-linux-3859397.zip && \
    tools/bin/sdkmanager "build-tools;26.0.1" "platform-tools" "platforms;android-26" && \
    chown -R videolan /sdk

ENV LANG en_US.UTF-8
USER videolan
