#!make
DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
PROJECT_NAME:=$(strip $(shell basename $(DIR)))
DOCKER_IMAGE=dsuite/$(PROJECT_NAME)

# env file
include $(DIR)/make.env


build: build-12 build-13 build-14 build-15 build-16 build-17

test: test-12 test-13 test-14 test-15 test-16 test-17

push: push-12 push-13 push-14 push-15 push-16 push-17


build-12:
	@docker run --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e NEXTCLOUD_PHP=$(NEXTCLOUD_12_PHP) \
		-e NEXTCLOUD_MAJOR=$(NEXTCLOUD_12_MAJOR) \
		-e NEXTCLOUD_VERSION=$(NEXTCLOUD_12_VERSION) \
		-v $(DIR)/Dockerfiles:/data \
		dsuite/alpine-data \
		sh -c "templater Dockerfile.template > Dockerfile-$(NEXTCLOUD_12_MAJOR)"
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-$(NEXTCLOUD_12_MAJOR) \
		--tag $(DOCKER_IMAGE):$(NEXTCLOUD_12_MAJOR) \
		$(DIR)/Dockerfiles

build-13:
	@docker run --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e NEXTCLOUD_PHP=$(NEXTCLOUD_13_PHP) \
		-e NEXTCLOUD_MAJOR=$(NEXTCLOUD_13_MAJOR) \
		-e NEXTCLOUD_VERSION=$(NEXTCLOUD_13_VERSION) \
		-v $(DIR)/Dockerfiles:/data \
		dsuite/alpine-data \
		sh -c "templater Dockerfile.template > Dockerfile-$(NEXTCLOUD_13_MAJOR)"
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-$(NEXTCLOUD_13_MAJOR) \
		--tag $(DOCKER_IMAGE):$(NEXTCLOUD_13_MAJOR) \
		$(DIR)/Dockerfiles

build-14:
	@docker run --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e NEXTCLOUD_PHP=$(NEXTCLOUD_14_PHP) \
		-e NEXTCLOUD_MAJOR=$(NEXTCLOUD_14_MAJOR) \
		-e NEXTCLOUD_VERSION=$(NEXTCLOUD_14_VERSION) \
		-v $(DIR)/Dockerfiles:/data \
		dsuite/alpine-data \
		sh -c "templater Dockerfile.template > Dockerfile-$(NEXTCLOUD_14_MAJOR)"
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-$(NEXTCLOUD_14_MAJOR) \
		--tag $(DOCKER_IMAGE):$(NEXTCLOUD_14_MAJOR) \
		$(DIR)/Dockerfiles

build-15:
	@docker run --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e NEXTCLOUD_PHP=$(NEXTCLOUD_15_PHP) \
		-e NEXTCLOUD_MAJOR=$(NEXTCLOUD_15_MAJOR) \
		-e NEXTCLOUD_VERSION=$(NEXTCLOUD_15_VERSION) \
		-v $(DIR)/Dockerfiles:/data \
		dsuite/alpine-data \
		sh -c "templater Dockerfile.template > Dockerfile-$(NEXTCLOUD_15_MAJOR)"
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-$(NEXTCLOUD_15_MAJOR) \
		--tag $(DOCKER_IMAGE):$(NEXTCLOUD_15_MAJOR) \
		$(DIR)/Dockerfiles
	@docker tag $(DOCKER_IMAGE):$(NEXTCLOUD_15_MAJOR) $(DOCKER_IMAGE):latest

build-16:
	@docker run --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e NEXTCLOUD_PHP=$(NEXTCLOUD_16_PHP) \
		-e NEXTCLOUD_MAJOR=$(NEXTCLOUD_16_MAJOR) \
		-e NEXTCLOUD_VERSION=$(NEXTCLOUD_16_VERSION) \
		-v $(DIR)/Dockerfiles:/data \
		dsuite/alpine-data \
		sh -c "templater Dockerfile.template > Dockerfile-$(NEXTCLOUD_16_MAJOR)"
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-$(NEXTCLOUD_16_MAJOR) \
		--tag $(DOCKER_IMAGE):$(NEXTCLOUD_16_MAJOR) \
		$(DIR)/Dockerfiles
	@docker tag $(DOCKER_IMAGE):$(NEXTCLOUD_16_MAJOR) $(DOCKER_IMAGE):latest

build-17:
	@docker run --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e NEXTCLOUD_PHP=$(NEXTCLOUD_17_PHP) \
		-e NEXTCLOUD_MAJOR=$(NEXTCLOUD_17_MAJOR) \
		-e NEXTCLOUD_VERSION=$(NEXTCLOUD_17_VERSION) \
		-v $(DIR)/Dockerfiles:/data \
		dsuite/alpine-data \
		sh -c "templater Dockerfile.template > Dockerfile-$(NEXTCLOUD_17_MAJOR)"
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-$(NEXTCLOUD_17_MAJOR) \
		--tag $(DOCKER_IMAGE):$(NEXTCLOUD_17_MAJOR) \
		$(DIR)/Dockerfiles
	@docker tag $(DOCKER_IMAGE):$(NEXTCLOUD_17_MAJOR) $(DOCKER_IMAGE):latest

test-12: build-12
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):$(NEXTCLOUD_12_MAJOR)

test-13: build-13
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):$(NEXTCLOUD_13_MAJOR)

test-14: build-14
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):$(NEXTCLOUD_14_MAJOR)

test-15: build-15
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):$(NEXTCLOUD_15_MAJOR)

test-16: build-16
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):$(NEXTCLOUD_16_MAJOR)

test-17: build-17
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):$(NEXTCLOUD_17_MAJOR)


push-12: build-12
	@docker push $(DOCKER_IMAGE):$(NEXTCLOUD_12_MAJOR)

push-13: build-13
	@docker push $(DOCKER_IMAGE):$(NEXTCLOUD_13_MAJOR)

push-14: build-14
	@docker push $(DOCKER_IMAGE):$(NEXTCLOUD_14_MAJOR)

push-15: build-15
	@docker push $(DOCKER_IMAGE):$(NEXTCLOUD_15_MAJOR)

push-16: build-16
	@docker push $(DOCKER_IMAGE):$(NEXTCLOUD_16_MAJOR)
	@docker push $(DOCKER_IMAGE):latest

push-17: build-17
	@docker push $(DOCKER_IMAGE):$(NEXTCLOUD_17_MAJOR)
	@docker push $(DOCKER_IMAGE):latest


shell-12: build-12
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		--name nextcloud-12 \
		$(DOCKER_IMAGE):$(NEXTCLOUD_12_MAJOR) \
		bash

shell-13: build-13
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		--name nextcloud-13 \
		$(DOCKER_IMAGE):$(NEXTCLOUD_13_MAJOR) \
		bash

shell-14: build-14
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		--name nextcloud-14 \
		$(DOCKER_IMAGE):$(NEXTCLOUD_14_MAJOR) \
		bash

shell-15: build-15
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		--name nextcloud-15 \
		$(DOCKER_IMAGE):$(NEXTCLOUD_15_MAJOR) \
		bash

shell-16: build-16
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		--name nextcloud-16 \
		$(DOCKER_IMAGE):$(NEXTCLOUD_16_MAJOR) \
		bash

shell-17: build-17
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		--name nextcloud-17 \
		$(DOCKER_IMAGE):$(NEXTCLOUD_17_MAJOR) \
		bash

remove:
	@docker images | grep $(DOCKER_IMAGE) | tr -s ' ' | cut -d ' ' -f 2 | xargs -I {} docker rmi $(DOCKER_IMAGE):{}

readme:
	@docker run -t --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		-e DOCKER_USERNAME=${DOCKER_USERNAME} \
		-e DOCKER_PASSWORD=${DOCKER_PASSWORD} \
		-e DOCKER_IMAGE=${DOCKER_IMAGE} \
		-v $(DIR):/data \
		dsuite/hub-updater
