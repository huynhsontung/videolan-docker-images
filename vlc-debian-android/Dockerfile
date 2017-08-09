FROM registry.videolan.org:5000/videolan-base-stretch:latest

ENV IMAGE_DATE=201708090859

RUN dpkg --add-architecture i386 && apt-get update && \
    apt-get install -y autoconf m4 automake ant autopoint cmake \
    build-essential libtool libtool-bin patch pkg-config ragel subversion \
    git rpm2cpio libwebkitgtk-1.0-0 yasm ragel g++ protobuf-compiler gettext \
    libgsm1-dev wget expect unzip python \
    zlib1g:i386 libstdc++6:i386 libc6:i386 && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

# install android sdk
RUN mkdir sdk && cd sdk && \
    wget http://dl.google.com/android/repository/android-ndk-r14b-linux-x86_64.zip && \
    unzip android-ndk-r14b-linux-x86_64.zip && \
    rm -f android-ndk-r14b-linux-x86_64.zip && \
    ln -s android-ndk-r14b android-ndk && \
    mkdir android-sdk-linux && \
    cd android-sdk-linux && \
    mkdir "licenses" && \
    echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > "licenses/android-sdk-license" && \
    wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
    unzip sdk-tools-linux-3859397.zip && \
    rm -f sdk-tools-linux-3859397.zip && \
    tools/bin/sdkmanager "build-tools;26.0.1" "platform-tools" "platforms;android-26" && \
    chown -R jenkins /sdk
