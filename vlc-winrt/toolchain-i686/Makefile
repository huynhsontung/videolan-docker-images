.PHONY: build

build:
	docker build -t jenkins-vlc-winrt-i686:latest .

push: build
	docker tag jenkins-vlc-winrt-i686:latest registry.videolan.org:5000/jenkins-vlc-winrt-i686:latest
	docker push registry.videolan.org:5000/jenkins-vlc-winrt-i686:latest
