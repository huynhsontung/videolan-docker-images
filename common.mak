SWARM		:= -H 10.10.1.103:3376
REGISTRY	:= registry.videolan.org:5000
TAG			:= $(notdir $(CURDIR))

.PHONY: build push swarm

all:

build:
	docker build -t $(TAG):latest .

push:
	docker tag $(TAG):latest $(REGISTRY)/$(TAG):latest
	docker push $(REGISTRY)/$(TAG):latest

swarm:
	docker $(SWARM) pull $(REGISTRY)/$(TAG):latest
