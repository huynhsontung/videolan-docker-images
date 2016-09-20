.PHONY: build

build:
	docker build -t jenkins-x264-debian-stable:latest .

push: build
	docker tag jenkins-x264-debian-stable:latest registry.videolan.org:5000/jenkins-x264-debian-stable:latest
	docker push registry.videolan.org:5000/jenkins-x264-debian-stable:latest
