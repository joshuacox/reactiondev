all: build clean run ps

build:
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
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-v $(REACTION_ROOT):/home/node/reaction \
		-v $(TMP):/tmp \
		$(TAG)

i: PORT REACTION_ROOT clean
	$(eval TAG := $(shell cat TAG))
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	$(eval TMP := $(shell mktemp -d --suffix=REACTION_TMP))
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-v $(REACTION_ROOT):/home/node/reaction \
		-v $(TMP):/tmp \
		$(TAG) \
		meteor npm i

test: PORT REACTION_ROOT i clean
	$(eval TAG := $(shell cat TAG))
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	$(eval TMP := $(shell mktemp -d --suffix=REACTION_TMP))
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-v $(REACTION_ROOT):/home/node/reaction \
		-v $(TMP):/tmp \
		$(TAG) \
		reaction test

demo:
	docker run --name reactiondevdemo \
		-d \
		-p 3001:3000 \
		--cidfile=.reactiondev.cid \
		joshuacox/reactiondev:demo

enter:
	docker exec -it \
		`cat .reactiondev.cid` \
		/bin/bash

logs:
	docker logs -f `cat .reactiondev.cid`

clean:
	-@echo -n 'Cleaning up..'
	-@touch .reactiondev.cid
	-@docker stop `cat .reactiondev.cid` &>/dev/null || true
	-@echo -n '..'
	-@docker rm `cat .reactiondev.cid` &>/dev/null || true
	-@echo -n '..'
	-@rm -f .reactiondev.cid
	-@echo  '...'

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

alpine: clean
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-v $(REACTION_ROOT):/home/node/reaction \
		joshuacox/reactiondev:alpine

marketplace: clean
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-v $(REACTION_ROOT):/home/node/reaction \
		joshuacox/reactiondev:marketplace

node-8: clean
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-v $(REACTION_ROOT):/home/node/reaction \
		joshuacox/reactiondev:node-8

node-8.4: clean
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-v $(REACTION_ROOT):/home/node/reaction \
		joshuacox/reactiondev:node-8.4

node-argon: clean
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-v $(REACTION_ROOT):/home/node/reaction \
		joshuacox/reactiondev:node-argon

node-boron: clean
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-v $(REACTION_ROOT):/home/node/reaction \
		joshuacox/reactiondev:node-boron

node-onbuild: clean
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-v $(REACTION_ROOT):/home/node/reaction \
		joshuacox/reactiondev:node-onbuild

node-slim: clean
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-v $(REACTION_ROOT):/home/node/reaction \
		joshuacox/reactiondev:node-slim

node-stretch: clean
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-v $(REACTION_ROOT):/home/node/reaction \
		joshuacox/reactiondev:node-stretch

node-wheezy: clean
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-v $(REACTION_ROOT):/home/node/reaction \
		joshuacox/reactiondev:node-wheezy
