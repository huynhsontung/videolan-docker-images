.PHONY: build

build:
	docker build -t jenkins-vlc-winrt-x86_64:latest .

push: build
	docker tag jenkins-vlc-winrt-x86_64:latest registry.videolan.org:5000/jenkins-vlc-winrt-x86_64:latest
	docker push registry.videolan.org:5000/jenkins-vlc-winrt-x86_64:latest
