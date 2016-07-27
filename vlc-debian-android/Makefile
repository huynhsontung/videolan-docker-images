.PHONY: build

build:
	docker build -t jenkins-vlc-android:latest .

push: build
	docker tag jenkins-vlc-android:latest registry.videolan.org:5000/jenkins-vlc-android:latest
	docker push registry.videolan.org:5000/jenkins-vlc-android:latest
