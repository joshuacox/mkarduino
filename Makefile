.PHONY: all help build run builddocker rundocker kill rm-image rm clean enter logs

user = $(shell whoami)
ifeq ($(user),root)
$(error  "do not run as root! run 'gpasswd -a USER docker' on the user of your choice")
endif

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
run: build rundocker

# run a  container that requires mysql temporarily
temp: MYSQL_PASS rm build mysqltemp runmysqltemp

# run a  container that requires mysql in production with persistent data
# HINT: use the grabmysqldatadir recipe to grab the data directory automatically from the above runmysqltemp
prod: APACHE_DATADIR MYSQL_DATADIR MYSQL_PASS rm build mysqlcid runprod

jessie:
	sudo bash local-jessie.sh

## useful hints
## specifiy ports
#-p 44180:80 \
#-p 27005:27005/udp \
## link another container
#--link some-mysql:mysql \
## assign environmant variables
#--env STEAM_USERNAME=`cat steam_username` \
#--env STEAM_PASSWORD=`cat steam_password` \

# change uid in the container for easy dev work
# first you need to determin your user:
# $(eval UID := $(shell id -u))
# then you need to insert this as a env var:
# -e "DOCKER_UID=$(UID)" \
# then look at chguid.sh for an example of 
# what needs to be run in the live container upon startup

rundocker:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	$(eval NAME := $(shell cat NAME))
	$(eval TAG := $(shell cat TAG))
	chmod 777 $(TMP)
	@docker run --name=$(NAME) \
	--cidfile="cid" \
	-v $(TMP):/tmp \
	-d \
	-P \
	-v /var/run/docker.sock:/run/docker.sock \
	-v $(shell which docker):/bin/docker \
	-v $(shell cat GIT_DATADIR):/home/git \
	-t $(TAG)

builddocker:
	/usr/bin/time -v docker build -t `cat TAG` .

kill:
	-@docker kill `cat cid`

rm-image:
	-@docker rm `cat cid`
	-@rm cid

rm: kill rm-image

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

grab: grabapachedir

grabapachedir:
	-mkdir -p datadir
	docker cp `cat cid`:/var/www/html  - |sudo tar -C datadir/ -pxvf -
	echo `pwd`/datadir/html > APACHE_DATADIR

GIT_DATADIR:
	@while [ -z "$$GIT_DATADIR" ]; do \
		read -r -p "Enter the destination of the Apache data directory you wish to associate with this container [GIT_DATADIR]: " GIT_DATADIR; echo "$$GIT_DATADIR">>GIT_DATADIR; cat GIT_DATADIR; \
	done ;

