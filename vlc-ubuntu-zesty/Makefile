.PHONY: build

build:
	docker build -t jenkins-vlc-zesty:latest .

push: build
	docker tag jenkins-vlc-zesty:latest registry.videolan.org:5000/jenkins-vlc-zesty:latest
	docker push registry.videolan.org:5000/jenkins-vlc-zesty:latest
