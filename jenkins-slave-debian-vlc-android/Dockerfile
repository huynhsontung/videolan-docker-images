FROM debian:sid

MAINTAINER VideoLAN roots <roots@videolan.org>

# Install and configure a basic SSH server
RUN apt-get update &&\
    apt-get install -y openssh-server &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd &&\
    mkdir -p /var/run/sshd

# Install JDK 7 (latest edition)
RUN apt-get update &&\
    apt-get install -y openjdk-8-jdk &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Set user jenkins to the image
RUN adduser --quiet jenkins && \
    echo "jenkins:jenkins" | chpasswd

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

# install VLC deps

RUN apt-get update && \
    apt-get install -y autoconf m4 ant automake ant autopoint cmake \
    build-essential libtool libtool-bin patch pkg-config ragel subversion \
    unzip git rpm2cpio libwebkitgtk-1.0-0 yasm ragel unzip g++ \
    protobuf-compiler gettext libgsm1-dev chromium wget expect \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# install android sdk

RUN mkdir sdk && cd sdk && \
	wget http://dl.google.com/android/ndk/android-ndk-r10e-linux-x86_64.bin && \
	chmod +x android-ndk-r10e-linux-x86_64.bin && \
	./android-ndk-r10e-linux-x86_64.bin && \
	rm -f android-ndk-r10e-linux-x86_64.bin && \
	wget http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
	tar -xzf android-sdk_r24.4.1-linux.tgz && \
	rm -f android-sdk_r24.4.1-linux.tgz

RUN chown -R jenkins /sdk

#RUN cd sdk && cd android-sdk-linux && \
#	/accept-licenses.sh tools/android update sdk -u -a --filter \
#		tool,platform-tool,platform,build-tools,extra-android-support,extra-android-m2repository
