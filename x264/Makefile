.PHONY: build

build:
	docker build -t jenkins-x264:latest .

push: build
	docker tag jenkins-x264:latest registry.videolan.org:5000/jenkins-x264:latest
	docker push registry.videolan.org:5000/jenkins-x264:latest
