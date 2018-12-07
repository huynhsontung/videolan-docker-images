FROM docker:18.09

MAINTAINER VideoLAN roots <roots@videolan.org>

# If someone wants to use VideoLAN docker images on a local machine and does
# not want to be disturbed by the jenkins user, we should not take an uid/gid
# in the user range of main distributions, which means:
# - Debian based: <1000
# - RPM based: <500 (CentOS, RedHat, etc.)
ARG JENKINS_UID=499

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
	addgroup -g ${JENKINS_UID} jenkins && \
	adduser -D -u ${JENKINS_UID} -G jenkins -s /bin/sh jenkins && \
	echo "jenkins:jenkins" | chpasswd

VOLUME /var/lib/docker
EXPOSE 2375
EXPOSE 22

ENTRYPOINT ["dockerd-entrypoint.sh"]
CMD []
