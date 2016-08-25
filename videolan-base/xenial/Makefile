.PHONY: build

build:
	docker build -t videolan-base-xenial:latest .

push: build
	docker tag videolan-base-xenial:latest registry.videolan.org:5000/videolan-base-xenial:latest
	docker push registry.videolan.org:5000/videolan-base-xenial:latest
