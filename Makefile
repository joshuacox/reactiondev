all: run ps logs

localbuild:
	$(eval TAG := $(shell cat TAG))
	docker build -t $(TAG) .

pull:
	$(eval TAG := $(shell cat TAG))
	docker pull $(TAG)

run: clean .reactiondev.cid

.reactiondev.cid: PORT REACTION_ROOT
	$(eval TAG := $(shell cat TAG))
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	$(eval TMP := $(shell mktemp -d --suffix=REACTION_TMP))
	@echo $(TMP) >> .tmplist
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-v $(REACTION_ROOT):/home/node/reaction \
		-v $(TMP):/tmp \
		$(TAG)

i:
	./scripts/cmd meteor npm i

t: test

test:
	./scripts/cmd reaction test

cmd: command logs

command: PORT REACTION_ROOT clean
	$(eval TAG := $(shell cat TAG))
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	$(eval TMP := $(shell mktemp -d --suffix=REACTION_TMP))
	@echo $(TMP) >> .tmplist
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-v $(REACTION_ROOT):/home/node/reaction \
		-v $(TMP):/tmp \
		$(TAG) \
		$(REACTION_CMD)

build: rcbuild logs

rcbuild: PORT REACTION_ROOT clean
	$(eval TAG := $(shell cat TAG))
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	$(eval TMP := $(shell mktemp -d --suffix=REACTION_TMP))
	@echo $(TMP) >> .tmplist
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-v $(REACTION_ROOT):/home/node/reaction \
		-v $(TMP):/tmp \
		--privileged \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v $(shell which docker):/bin/docker \
		$(TAG) \
		reaction build $(REACTION_BUILD_NAME)

ls:
	  ls -lh /var/run/docker.sock
		sudo reaction build $(REACTION_BUILD_NAME)
		docker ps

tag: tagged logs

tagged: PORT REACTION_ROOT clean
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	$(eval TMP := $(shell mktemp -d --suffix=REACTION_TMP))
	@echo $(TMP) >> .tmplist
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-v $(REACTION_ROOT):/home/node/reaction \
		-v $(TMP):/tmp \
		$(TAG)

demo:
	PORT=3100 TAG="joshuacox/reactiondev:demo" make demod

demod:
	docker run -d \
		-p $(PORT):3000 \
		$(TAG)

enter:
	docker exec -it \
		`cat .reactiondev.cid` \
		/bin/bash

logs:
	docker logs -f `cat .reactiondev.cid`

clean:
	-@echo -n 'Stopping and Removing any running reactiondev containers..'
	-@touch .reactiondev.cid
	-@docker stop `cat .reactiondev.cid` &>/dev/null || true
	-@echo -n '..'
	-@docker rm `cat .reactiondev.cid` &>/dev/null || true
	-@echo '..'
	-@rm -f .reactiondev.cid
	-@./scripts/rmdirs
	-@echo  'clean....'
	-@echo  'Ready to run reactiondev'

ps:
	-@sleep 2
	docker ps|grep reactiondev

PORT:
	@while [ -z "$$PORT" ]; do \
		read -r -p "Enter the port you wish to associate with this container [PORT]: " PORT; echo "$$PORT">>PORT; cat PORT; \
	done ;

REACTION_ROOT:
	@while [ -z "$$REACTION_ROOT" ]; do \
		read -r -p "Enter the reaction root you wish to associate with this container [REACTION_ROOT]: " REACTION_ROOT; echo "$$REACTION_ROOT">>REACTION_ROOT; cat REACTION_ROOT; \
	done ;

REACTION_BUILD_NAME:
	@while [ -z "$$REACTION_BUILD_NAME" ]; do \
		read -r -p "Enter the reaction build name [REACTION_BUILD_NAME]: " REACTION_BUILD_NAME; echo "$$REACTION_BUILD_NAME">>REACTION_BUILD_NAME; cat REACTION_BUILD_NAME; \
	done ;

alpine: clean
	./scripts/tagged joshuacox/reactiondev:alpine

node-8: clean
	./scripts/tagged joshuacox/reactiondev:node-8

node-8.4: clean
	./scripts/tagged joshuacox/reactiondev:node-8.4

node-argon: clean
	./scripts/tagged joshuacox/reactiondev:node-argon

node-boron: clean
	./scripts/tagged joshuacox/reactiondev:node-boron

node-onbuild: clean
	./scripts/tagged joshuacox/reactiondev:node-onbuild

node-slim: clean
	./scripts/tagged joshuacox/reactiondev:node-slim

node-stretch: clean
	./scripts/tagged joshuacox/reactiondev:node-stretch

node-wheezy: clean
	./scripts/tagged joshuacox/reactiondev:node-wheezy

demos: v141 v140 v130 marketplace

v141:
	./scripts/demo joshuacox/reactiondev:v1.4.1 3141

v140:
	./scripts/demo joshuacox/reactiondev:v1.4.0 3140

v130:
	./scripts/demo joshuacox/reactiondev:v1.3.0 3130

marketplace:
	./scripts/demo joshuacox/reactiondev:marketplace 3101
