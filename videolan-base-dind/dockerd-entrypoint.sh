#!/bin/sh
set -ex

dind docker daemon \
		--host=unix:///var/run/docker.sock \
		--host=tcp://0.0.0.0:2375 \
		--storage-driver=vfs &

ssh-keygen -A

exec "$@"
