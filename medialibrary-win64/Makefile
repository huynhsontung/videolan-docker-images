.PHONY: build

build:
	docker build -t medialibrary-win64:latest .

push: build
	docker tag medialibrary-win64:latest registry.videolan.org:5000/medialibrary-win64:latest
	docker push registry.videolan.org:5000/medialibrary-win64:latest
