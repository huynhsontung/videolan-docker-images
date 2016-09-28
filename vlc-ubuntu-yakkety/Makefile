.PHONY: build

build:
	docker build -t jenkins-vlc-yakkety:latest .

push: build
	docker tag jenkins-vlc-yakkety:latest registry.videolan.org:5000/jenkins-vlc-yakkety:latest
	docker push registry.videolan.org:5000/jenkins-vlc-yakkety:latest
