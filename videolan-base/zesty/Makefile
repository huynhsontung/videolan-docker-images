.PHONY: build

build:
	docker build -t videolan-base-zesty:latest .

push: build
	docker tag videolan-base-zesty:latest registry.videolan.org:5000/videolan-base-zesty:latest
	docker push registry.videolan.org:5000/videolan-base-zesty:latest
