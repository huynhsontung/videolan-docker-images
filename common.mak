SWARM		:= -H 10.10.1.103:3376
REGISTRY	:= registry.videolan.org:5000
TAG			:= $(notdir $(CURDIR))

.PHONY: build push swarm

all:

build:
	docker build -t $(TAG):$(REVISION) .

push:
	docker tag $(TAG):$(REVISION) $(REGISTRY)/$(TAG)
	docker push $(REGISTRY)/$(TAG)

swarm:
	docker $(SWARM) pull $(REGISTRY)/$(TAG)
