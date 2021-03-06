all: run ps logs

localbuild:
	$(eval TAG := $(shell cat TAG))
	docker build -t $(TAG) .

pull:
	$(eval TAG := $(shell cat TAG))
	docker pull $(TAG)

run: clean .reactiondev.cid

.reactiondev.cid: PORT REACTION_ROOT TOOL_NODE_FLAGS
	$(eval TAG := $(shell cat TAG))
	$(eval PORT := $(shell cat PORT))
	$(eval TOOL_NODE_FLAGS := $(shell cat TOOL_NODE_FLAGS))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	$(eval TMP := $(shell mktemp -d --suffix=REACTION_TMP))
	@echo $(TMP) >> .tmplist
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-e TOOL_NODE_FLAGS=$(TOOL_NODE_FLAGS) \
		-v $(REACTION_ROOT):/home/node/reaction \
		-v $(TMP):/tmp \
		$(TAG)

i:
	./scripts/cmd meteor npm i

t: test

test:
	./scripts/cmd reaction test

try: .reactiontry.cid

cmd: command logs clean

command: PORT REACTION_ROOT clean TOOL_NODE_FLAGS
	$(eval TAG := $(shell cat TAG))
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	$(eval TOOL_NODE_FLAGS := $(shell cat TOOL_NODE_FLAGS))
	$(eval TMP := $(shell mktemp -d --suffix=REACTION_TMP))
	@echo $(TMP) >> .tmplist
	docker run --name reactiondev \
		-d \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-e TOOL_NODE_FLAGS=$(TOOL_NODE_FLAGS) \
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

tagged: PORT REACTION_ROOT clean TOOL_NODE_FLAGS
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	$(eval TOOL_NODE_FLAGS := $(shell cat TOOL_NODE_FLAGS))
	$(eval TMP := $(shell mktemp -d --suffix=REACTION_TMP))
	@echo $(TMP) >> .tmplist
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-e TOOL_NODE_FLAGS=$(TOOL_NODE_FLAGS) \
		-v $(REACTION_ROOT):/home/node/reaction \
		-v $(TMP):/tmp \
		$(TAG)

demo:
	PORT=3100 TAG="joshuacox/reactiondev:demo" make demod

demod: TOOL_NODE_FLAGS
	$(eval TOOL_NODE_FLAGS := $(shell cat TOOL_NODE_FLAGS))
	docker run -d \
		-p $(PORT):3000 \
		-e TOOL_NODE_FLAGS=$(TOOL_NODE_FLAGS) \
		$(TAG)

.reactiontry.cid: clean PORT TRY .mongotry.cid
	$(eval TRY := $(shell cat TRY))
	$(eval PORT := $(shell cat PORT))
	docker run --name reactiontry \
		-d \
		--link mongotry:mongo \
		-p $(PORT):3000 \
		-e MONGO_URL='mongodb://mongo/test' \
		-e REACTION_AUTH='test' \
		-e REACTION_USER='test' \
		-e REACTION_EMAIL='test@test.com' \
		--cidfile=.reactiondev.cid \
		$(TRY)

.mongotry.cid:
	$(eval TRY := $(shell cat TRY))
	docker run --name mongotry \
		-d \
		--cidfile=.mongotry.cid \
	  mongo:latest

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

TRY:
	@while [ -z "$$TRY" ]; do \
		read -r -p "Enter the tag you wish to try [TRY]: " TRY; echo "$$TRY">>TRY; cat TRY; \
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
	make i
	make

/tmp/reaction:
	cd /tmp; git clone https://github.com/reactioncommerce/reaction.git

BUILD_ARGS: TOOL_NODE_FLAGS
	$(eval TOOL_NODE_FLAGS := $(shell cat TOOL_NODE_FLAGS))
	echo '--build-arg TOOL_NODE_FLAGS=$(TOOL_NODE_FLAGS)' > BUILD_ARGS

TOOL_NODE_FLAGS:
	echo '"--max-old-space-size=4096"' > TOOL_NODE_FLAGS

docker-entrypoint.sh:
	wget -c https://raw.githubusercontent.com/docker-library/docker/62a456489acfe7443d426cd502ccf22130d1ccf9/17.10/docker-entrypoint.sh
	chmod +x docker-entrypoint.sh
