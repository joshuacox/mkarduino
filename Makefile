.PHONY: all help build run builddocker rundocker kill rm-image rm clean enter logs

all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   1. make run       - build and run docker container
	@echo ""   2. make build     - build docker container
	@echo ""   3. make clean     - kill and remove docker container
	@echo ""   4. make enter     - execute an interactive bash in docker container
	@echo ""   3. make logs      - follow the logs of docker container

build: NAME TAG builddocker

# run a plain container
run: GIT_DATADIR SKETCHBOOK local-preferences build rm .Xauthority rundocker

echo:
	echo $(DISPLAY)

rundocker:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	$(eval NAME := $(shell cat NAME))
	$(eval TAG := $(shell cat TAG))
	$(eval PWD := $(shell pwd ))
	chmod 777 $(TMP)
	@docker run --name=$(NAME) \
	--cidfile="cid" \
	-v $(TMP):/tmp \
	-d \
	-P \
	--device /dev/dri \
	-e DISPLAY=$(DISPLAY) \
	--volume=/tmp/.X11-unix:/tmp/.X11-unix:rw \
	--volume=$(PWD)/.Xauthority:/home/arduino/.Xauthority:ro \
	-e XAUTHORITY=/home/arduino/.Xauthority \
	--privileged \
	-v /var/run/docker.sock:/run/docker.sock \
	-v $(PWD)/local-preferences:/home/arduino/.arduino \
	-v $(shell which docker):/bin/docker \
	-v $(shell cat GIT_DATADIR):/home/git \
	-v $(shell cat SKETCHBOOK):/home/arduino/Arduino \
	-t $(TAG)

sparevolumes:


builddocker:
	/usr/bin/time -v docker build -t `cat TAG` .

kill:
	-@docker kill `cat cid`

rm-image:
	-@docker rm `cat cid`
	-@rm cid

rm: kill rm-image rmxauth

clean: rm

enter:
	docker exec -i -t `cat cid` /bin/bash

logs:
	docker logs -f `cat cid`

NAME:
	@while [ -z "$$NAME" ]; do \
		read -r -p "Enter the name you wish to associate with this container [NAME]: " NAME; echo "$$NAME">>NAME; cat NAME; \
	done ;

TAG:
	@while [ -z "$$TAG" ]; do \
		read -r -p "Enter the tag you wish to associate with this container [TAG]: " TAG; echo "$$TAG">>TAG; cat TAG; \
	done ;

rmall: rm 

GIT_DATADIR:
	@while [ -z "$$GIT_DATADIR" ]; do \
		read -r -p "Enter the destination of th eGit data directory you wish to associate with this container [GIT_DATADIR]: " GIT_DATADIR; echo "$$GIT_DATADIR">>GIT_DATADIR; cat GIT_DATADIR; \
	done ;

SKETCHBOOK:
	@while [ -z "$$SKETCHBOOK" ]; do \
		read -r -p "Enter the destination of th esketchbook directory you wish to associate with this container [SKETCHBOOK]: " SKETCHBOOK; echo "$$SKETCHBOOK">>SKETCHBOOK; cat SKETCHBOOK; \
	done ;

local-preferences:
	mkdir local-preferences
	sudo chown -R 1001:1001 local-preferences

.Xauthority:
	xauth extract .Xauthority :0
	sudo chown 1001:1001 .Xauthority
	sudo chmod 640 .Xauthority

rmxauth:
	-@rm .Xauthority
