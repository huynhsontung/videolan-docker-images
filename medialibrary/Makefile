.PHONY: build

build:
	docker build -t medialibrary:latest .

push: build
	docker tag medialibrary:latest registry.videolan.org:5000/medialibrary:latest
	docker push registry.videolan.org:5000/medialibrary:latest
