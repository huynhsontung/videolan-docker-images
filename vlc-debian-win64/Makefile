.PHONY: build

build:
	docker build -t jenkins-vlc-win64:latest .

push: build
	docker tag jenkins-vlc-win64:latest registry.videolan.org:5000/jenkins-vlc-win64:latest
	docker push registry.videolan.org:5000/jenkins-vlc-win64:latest
