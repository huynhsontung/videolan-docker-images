.PHONY: build

build:
	docker build -t videolan-base-jessie:latest .

push: build
	docker tag videolan-base-jessie:latest registry.videolan.org:5000/videolan-base-jessie:latest
	docker push registry.videolan.org:5000/videolan-base-jessie:latest
