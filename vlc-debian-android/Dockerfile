FROM videolan-base-sid:latest

RUN dpkg --add-architecture i386 && apt-get update && \
    apt-get install -y autoconf m4 ant automake ant autopoint cmake \
    build-essential libtool libtool-bin patch pkg-config ragel subversion \
    unzip git rpm2cpio libwebkitgtk-1.0-0 yasm ragel unzip g++ \
    protobuf-compiler gettext libgsm1-dev chromium wget expect unzip \
    zlib1g:i386 libstdc++6:i386 libc6:i386 && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

# install android sdk
COPY accept-licenses.sh /root
RUN mkdir sdk && cd sdk && \
    wget http://dl.google.com/android/repository/android-ndk-r11c-linux-x86_64.zip && \
    unzip android-ndk-r11c-linux-x86_64.zip && \
    rm -f android-ndk-r11c-linux-x86_64.zip && \
    wget http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
    tar -xzf android-sdk_r24.4.1-linux.tgz && \
    rm -f android-sdk_r24.4.1-linux.tgz && \
    cd android-sdk-linux && \
    /root/accept-licenses.sh tools/android update sdk -u -t \
        $(tools/android list sdk | grep 'Android SDK Build-tools' | sed 's/ *\([0-9]\+\)\-.*/\1/'),$(tools/android list sdk | grep 'SDK Platform Android' | head -n 1 | sed 's/ *\([0-9]\+\)\-.*/\1/'),$(tools/android list sdk | grep 'Android SDK Tools' | sed 's/ *\([0-9]\+\)\-.*/\1/'),$(tools/android list sdk | grep 'Android SDK Platform-tools' | sed 's/ *\([0-9]\+\)\-.*/\1/') && \
    chown -R jenkins /sdk