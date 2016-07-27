.PHONY: build

build:
	docker build -t videolan-base-dind:latest .

push: build
	docker tag videolan-base-dind:latest registry.videolan.org:5000/videolan-base-dind:latest
	docker push registry.videolan.org:5000/videolan-base-dind:latest
