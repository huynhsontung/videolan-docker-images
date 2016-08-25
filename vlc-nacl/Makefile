.PHONY: build

build:
	docker build -t nacl-toolchains:latest .

push: build
	docker tag nacl-toolchains:latest registry.videolan.org:5000/nacl-toolchains:latest
	docker push registry.videolan.org:5000/nacl-toolchains:latest
