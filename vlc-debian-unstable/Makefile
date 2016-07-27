.PHONY: build

build:
	docker build -t jenkins-vlc-devel-debian-unstable:latest .

push: build
	docker tag jenkins-vlc-devel-debian-unstable:latest registry.videolan.org:5000/jenkins-vlc-devel-debian-unstable:latest
	docker push registry.videolan.org:5000/jenkins-vlc-devel-debian-unstable:latest
