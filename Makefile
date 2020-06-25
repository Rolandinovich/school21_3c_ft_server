DOCKER_USER := admin
IMAGE := ft_server_image
DOCKER_NAME := ft_server_container

build:
	docker build -t $(IMAGE) .

run:
	docker run -it -p 80:80 -p 443:443 --name $(DOCKER_NAME) $(IMAGE)

up: build run

stop:
	docker stop $(DOCKER_NAME)

start:
	docker start $(DOCKER_NAME)

rm: stop
	docker rm $(DOCKER_NAME)

rmi: rm
	docker rmi $(IMAGE)

clean: rm rmi

autoindex-on:
	docker exec $(DOCKER_NAME) bash /scripts/switch_autoindex.sh on

autoindex-off:
	docker exec $(DOCKER_NAME) bash /scripts/switch_autoindex.sh off
