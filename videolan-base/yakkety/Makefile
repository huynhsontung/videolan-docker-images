.PHONY: build

build:
	docker build -t videolan-base-yakkety:latest .

push: build
	docker tag videolan-base-yakkety:latest registry.videolan.org:5000/videolan-base-yakkety:latest
	docker push registry.videolan.org:5000/videolan-base-yakkety:latest
