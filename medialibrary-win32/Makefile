.PHONY: build

build:
	docker build -t medialibrary-win32:latest .

push: build
	docker tag medialibrary-win32:latest registry.videolan.org:5000/medialibrary-win32:latest
	docker push registry.videolan.org:5000/medialibrary-win32:latest
