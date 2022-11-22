FROM docker.io/amd64/alpine:3.17.0

MAINTAINER VideoLAN roots <roots@videolan.org>

ENV IMAGE_DATE=202211220000

RUN apk upgrade -U --no-cache && \
    apk add -U --no-cache buildah fuse-overlayfs git

RUN sed -e '/^#cgroup_manager/c cgroup_manager = "cgroupfs"' \
        -i /etc/containers/containers.conf && \
    sed -e 's/^#mount_program/mount_program/g' \
        -e 's/^mountopt[[:space:]]*=.*$/mountopt = "nodev,fsync=0"/g' \
        -i /etc/containers/storage.conf && \
    adduser -D -u 499 videolan && \
    echo -e "videolan:1:498\nvideolan:500:65036" > /etc/subuid && \
    echo -e "videolan:1:498\nvideolan:500:65036" > /etc/subgid && \
    mkdir -p /home/videolan/.local/share/containers && \
    chown -R videolan:videolan /home/videolan

ENV BUILDAH_ISOLATION=chroot

USER videolan
WORKDIR /builds
