# vlc-rs-libvlc-stable-ubuntu

## Description

This image is meant to build vlc-rs project, based on latest libvlc.
It's a simple ubuntu image with distribution `libvlc-dev` and Rust build environment.

## Local build

You can make local builds of this image, for example for local CI testing with gitlab-runner :

```
docker build -t registry.videolan.org/$(basename $PWD):$(grep IMAGE_DATE Dockerfile | sed -E 's/.*=([0-9]+)$/\1/') .
```
