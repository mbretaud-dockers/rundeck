CURRENT_DIR=$(shell pwd)

# Docker variables
RUNDECK_VERSION=2.9.4
DOCKER_CONTAINER_NAME=rundeck
DOCKER_CONTAINER_VERSION=$(RUNDECK_VERSION)
DOCKER_CONTAINER_VOLUME_PATH=/c/docker/volume-persistent/docker-rundeck/rundeck

# Rundeck variables
HTTP_PORT=4440
RUNDECK_FILE_JAR=$(CURRENT_DIR)/rundeck-jars/rundeck-launcher-$(RUNDECK_VERSION).jar
RUNDECK_URL=http://dl.bintray.com/rundeck/rundeck-maven/rundeck-launcher-$(RUNDECK_VERSION).jar

# Rundeck users variables
ADMIN_PASSWORD?=$(shell bash -c 'while [ -z "$$ADMIN_PASSWORD" ]; do read -r -p "Admin password: " ADMIN_PASSWORD; done; echo $$ADMIN_PASSWORD; echo ""')
USER_NAME=user
USER_PASSWORD?=$(shell bash -c 'while [ -z "$$USER_PASSWORD" ]; do read -r -p "User password: " USER_PASSWORD; done; echo $$USER_PASSWORD; echo ""')

# Makefile variables
buildArgs=--build-arg HTTP_PORT=$(HTTP_PORT) --build-arg RUNDECK_VER=$(RUNDECK_VERSION) --build-arg ADMIN_PASSWORD=$(ADMIN_PASSWORD) --build-arg USER_NAME=$(USER_NAME) --build-arg USER_PASSWORD=$(USER_PASSWORD)
containerName=$(DOCKER_CONTAINER_NAME)
containerPublish=--publish $(HTTP_PORT):$(HTTP_PORT)
containerVolumes=-v $(DOCKER_CONTAINER_VOLUME_PATH)/etc:/opt/rundeck/etc -v $(DOCKER_CONTAINER_VOLUME_PATH)/projects:/opt/rundeck/projects
containerImage=$(DOCKER_CONTAINER_NAME):$(DOCKER_CONTAINER_VERSION)

$(info ############################################### )
$(info # )
$(info # Environment variables )
$(info # )
$(info ############################################### )
$(info RUNDECK_VERSION: $(RUNDECK_VERSION))
$(info DOCKER_CONTAINER_NAME: $(DOCKER_CONTAINER_NAME))
$(info DOCKER_CONTAINER_VERSION: $(DOCKER_CONTAINER_VERSION))
$(info DOCKER_CONTAINER_VOLUME_PATH: $(DOCKER_CONTAINER_VOLUME_PATH))
$(info HTTP_PORT: $(HTTP_PORT))
$(info RUNDECK_FILE_JAR: $(RUNDECK_FILE_JAR))
$(info RUNDECK_URL: $(RUNDECK_URL))
$(info )
	
# Download the Rundeck jar from the internet if it does not exists in the directory '$(CURRENT_DIR)/rundeck-jars/'
ifeq (,$(wildcard $(RUNDECK_FILE_JAR)))
$(info ############################################### )
$(info # )
$(info # Download )
$(info # )
$(info ############################################### )
$(info Download the file $(RUNDECK_URL):)
$(shell curl -fsSL $(RUNDECK_URL) -o $(RUNDECK_FILE_JAR))
endif

include ./make-commons-docker.mk