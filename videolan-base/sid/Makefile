.PHONY: build

build:
	docker build -t videolan-base-sid:latest .

push: build
	docker tag videolan-base-sid:latest registry.videolan.org:5000/videolan-base-sid:latest
	docker push registry.videolan.org:5000/videolan-base-sid:latest
