FROM docker:1.11

MAINTAINER VideoLAN roots <roots@videolan.org>

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md#runtime-dependencies
RUN apk add --no-cache \
		btrfs-progs \
		e2fsprogs \
		e2fsprogs-extra \
		iptables \
		xfsprogs \
		xz \
		openssh \
		bash \
		openjdk8-jre-base \
		git \
		make

# TODO aufs-tools

# set up subuid/subgid so that "--userns-remap=default" works out-of-the-box
RUN set -x \
	&& addgroup -S dockremap \
	&& adduser -S -G dockremap dockremap \
	&& echo 'dockremap:165536:65536' >> /etc/subuid \
	&& echo 'dockremap:165536:65536' >> /etc/subgid

# https://raw.githubusercontent.com/docker/docker/3b5fac462d21ca164b3778647420016315289034/hack/dind
COPY dind /usr/local/bin
# from docker:dind, but we also need to launch sshd, so hacked a bit.
COPY dockerd-entrypoint.sh /usr/local/bin/

RUN mkdir -p /var/run/sshd && \
	adduser -D jenkins && \
	echo "jenkins:jenkins" | chpasswd

VOLUME /var/lib/docker
EXPOSE 2375
EXPOSE 22

ENTRYPOINT ["dockerd-entrypoint.sh"]
CMD []
