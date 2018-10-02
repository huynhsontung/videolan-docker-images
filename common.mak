REGISTRY	:= registry.videolan.org:5000
TAG			:= $(notdir $(CURDIR))
DATE		:= $(shell date +'%Y%m%d%H%M%S')

.PHONY: build push

all:

build:
	docker build -t $(TAG):$(REVISION) .

push:
	docker tag $(TAG):$(REVISION) $(REGISTRY)/$(TAG)
	docker tag $(TAG):$(REVISION) $(REGISTRY)/$(TAG):$(DATE)
	docker push $(REGISTRY)/$(TAG)
	docker push $(REGISTRY)/$(TAG):$(DATE)
