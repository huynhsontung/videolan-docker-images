#!/bin/sh

# this is a helper script to rebuild all base images and then all dependant images
# rebuilding dind image is too dangerous

BASE="jessie sid"

DEPS="vlc-debian-unstable vlc-debian-android vlc-debian-win32 vlc-debian-win64"

for type in $BASE; do
    make -C videolan-base/$type push
done

for dep in $DEPS; do
    make -C $dep push
done
