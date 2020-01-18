## Name of the image
DOCKER_IMAGE=dsuite/nextcloud

## Current directory
DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

## Define the latest version of nextcloud
latest = 17

# env file
include $(DIR)/make.env

##
.DEFAULT_GOAL := help
.PHONY: *


help: ## Display this help
	@printf "\n\033[33mUsage:\033[0m\n  make \033[32m<target>\033[0m \033[36m[\033[0marg=\"val\"...\033[36m]\033[0m\n\n\033[33mTargets:\033[0m\n"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[32m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


build: ## Build a specific version of nextcloud ( make build v=12)
	@$(eval version := $(or $(v),$(latest)))
	@docker run --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e NEXTCLOUD_PHP=$(NEXTCLOUD_$(version)_PHP) \
		-e NEXTCLOUD_MAJOR=$(NEXTCLOUD_$(version)_MAJOR) \
		-e NEXTCLOUD_VERSION=$(NEXTCLOUD_$(version)_VERSION) \
		-v $(DIR)/Dockerfiles:/data \
		dsuite/alpine-data \
		sh -c "templater Dockerfile.template > Dockerfile-$(NEXTCLOUD_$(version)_MAJOR)"
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-$(NEXTCLOUD_$(version)_MAJOR) \
		--tag $(DOCKER_IMAGE):$(NEXTCLOUD_$(version)_MAJOR) \
		$(DIR)/Dockerfiles
	@[ "$(version)" = "$(latest)" ] && docker tag $(DOCKER_IMAGE):$(NEXTCLOUD_$(version)_MAJOR) $(DOCKER_IMAGE):latest || true


test:  ## Test a specific version of nextcloud ( make test v=12)
	@$(eval version := $(or $(v),$(latest)))
	@$(MAKE) build v=$(version)
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):$(NEXTCLOUD_$(version)_MAJOR)


push: ## Push a specific version of nextcloud ( make push v=12)
	@$(eval version := $(or $(v),$(latest)))
	@docker push $(DOCKER_IMAGE):$(NEXTCLOUD_$(version)_MAJOR)


shell: ## Get command prompt inside container
	@$(eval version := $(or $(v),$(latest)))
	@$(MAKE) build v=$(version)
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		-e SQLITE_DATABASE=sqlite.db \
		-v $(DIR)/.tmp/www:/var/www \
		-v $(DIR)/.tmp/nextcloud:/nextcloud \
		-v $(DIR)/.tmp/log:/var/log \
		-v $(DIR)/.tmp/php-fpm.d:/etc/php/7.1/php-fpm.d \
		--name nextcloud-$(version)  \
		$(DOCKER_IMAGE):$(NEXTCLOUD_$(version)_MAJOR) \
		bash


remove: ## Remove all generated images
	@docker images | grep $(DOCKER_IMAGE) | tr -s ' ' | cut -d ' ' -f 2 | xargs -I {} docker rmi $(DOCKER_IMAGE):{} || true
	@docker images | grep $(DOCKER_IMAGE) | tr -s ' ' | cut -d ' ' -f 3 | xargs -I {} docker rmi {} || true


readme: ## Generate docker hub full description
	@docker run -t --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		-e DOCKER_USERNAME=${DOCKER_USERNAME} \
		-e DOCKER_PASSWORD=${DOCKER_PASSWORD} \
		-e DOCKER_IMAGE=${DOCKER_IMAGE} \
		-v $(DIR):/data \
		dsuite/hub-updater
