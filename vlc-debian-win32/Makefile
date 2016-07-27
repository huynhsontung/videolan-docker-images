.PHONY: build

build:
	docker build -t jenkins-vlc-win32:latest .

push: build
	docker tag jenkins-vlc-win32:latest registry.videolan.org:5000/jenkins-vlc-win32:latest
	docker push registry.videolan.org:5000/jenkins-vlc-win32:latest
