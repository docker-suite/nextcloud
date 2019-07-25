#!make
DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

build:
	echo "**** Build containers ****"
	docker-compose --project-name nextcloud build

run: build
	echo "**** Running containers ... ****"
	docker-compose --project-name nextcloud up

stop:
	echo "**** Stopping containers ... ****"
	docker-compose --project-name nextcloud down

clean:
	docker ps -q --filter "name=nextcloud_*" | xargs -I {} docker stop {}
	docker ps -a -q --filter "name=nextcloud_*" | xargs -I {} docker rm -fv {}
	docker volume ls -q --filter "name=nextcloud_*" | xargs -I {} docker volume rm -f {}
	docker volume ls -q --filter "dangling=true" | xargs -I {} docker volume rm -f {}
	docker network ls -q --filter "name=nextcloud_*" | xargs -I {} docker network rm {}
	docker images -q "nextcloud_*" | xargs -I {} docker rmi -f {}
	docker images -q --filter "dangling=true" | xargs -I {} docker rmi -f {}

remove: clean
	rm -rf $(DIR)/tmp
