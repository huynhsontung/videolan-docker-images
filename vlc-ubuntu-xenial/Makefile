.PHONY: build

build:
	docker build -t jenkins-vlc-xenial:latest .

push: build
	docker tag jenkins-vlc-xenial:latest registry.videolan.org:5000/jenkins-vlc-xenial:latest
	docker push registry.videolan.org:5000/jenkins-vlc-xenial:latest
