SHELL = /bin/sh
DOCKER_USER := admin
IMAGE := ft_server
DOCKER_NAME := ft_server1

build:
	docker build -t $(IMAGE) .

run:
	docker run -it -p 80:80 -p 443:443 --name $(DOCKER_NAME) $(IMAGE) -d

up: build run

stop:
	docker stop $(DOCKER_NAME)

rm: stop
	docker rm $(DOCKER_NAME)

rmi:
	docker rmi $(IMAGE)

.PHONY: clean
clean: rm rmi

autoindex-on:
	docker exec $(DOCKER_NAME) bash /scripts/switch_autoindex.sh on

autoindex-off:
	docker exec $(DOCKER_NAME) bash /scripts/switch_autoindex.sh off
