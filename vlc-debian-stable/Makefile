.PHONY: build

build:
	docker build -t jenkins-vlc-devel-debian-stable:latest .

push: build
	docker tag jenkins-vlc-devel-debian-stable:latest registry.videolan.org:5000/jenkins-vlc-devel-debian-stable:latest
	docker push registry.videolan.org:5000/jenkins-vlc-devel-debian-stable:latest
