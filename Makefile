all: run ps logs

localbuild:
	$(eval TAG := $(shell cat TAG))
	docker build -t $(TAG) .

pull:
	$(eval TAG := $(shell cat TAG))
	docker pull $(TAG)

run: clean .reactiondev.cid

.reactiondev.cid: PORT REACTION_ROOT STRACE_OPTS
	$(eval TAG := $(shell cat TAG))
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	$(eval TMP := $(shell mktemp -d --suffix=REACTION_TMP))
	$(eval STRACE_OPTS := $(shell cat STRACE_OPTS))
	@echo $(TMP) >> .tmplist
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-e STRACE_OPTS=$(STRACE_OPTS) \
		-v $(REACTION_ROOT):/home/node/reaction \
		-v $(TMP):/tmp \
		--cap-add SYS_PTRACE \
		--security-opt seccomp:unconfined \
		--privileged \
		$(TAG)

i:
	./scripts/cmd meteor npm i

t: test

test:
	./scripts/cmd reaction test

cmd: command logs clean

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

rcbuild: REACTION_BUILD_NAME clean
	$(eval REACTION_BUILD_NAME := $(shell cat REACTION_BUILD_NAME))
	./build $(REACTION_BUILD_NAME)

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
	-@./scripts/clean

ps:
	-@sleep 2
	docker ps|grep reactiondev

STRACE_OPTS:
	@while [ -z "$$STRACE_OPTS" ]; do \
		read -r -p "Enter the strace options you wish to associate with this container [STRACE_OPTS]: " STRACE_OPTS; echo "$$STRACE_OPTS">>STRACE_OPTS; cat STRACE_OPTS; \
	done ;

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

install-meteor.sh:
	wget -c https://raw.githubusercontent.com/reactioncommerce/base/master/scripts/install-meteor.sh

fresh: PORT clean /tmp/reaction
	echo '/tmp/reaction' > REACTION_ROOT
	make

/tmp/reaction:
	cd /tmp; git clone https://github.com/reactioncommerce/reaction.git
	cd /tmp/reaction; meteor npm i

