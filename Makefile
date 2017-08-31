TAG:=joshuacox/reactiondev

all: build clean run ps

build:
	docker build -t $(TAG) .

pull:
	docker pull $(TAG)

run: .reactiondev.cid

.reactiondev.cid: PORT REACTION_ROOT
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-e REACTION_ROOT=/home/node/reaction \
		-v $(REACTION_ROOT):/home/node/reaction \
		joshuacox/reactiondev

demo: PORT
	$(eval PORT := $(shell cat PORT))
	$(eval REACTION_ROOT := $(shell cat REACTION_ROOT))
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		joshuacox/reactiondev

enter:
	docker exec -it \
		`cat .reactiondev.cid` \
		/bin/bash

logs:
	docker logs -f `cat .reactiondev.cid`

clean:
	-docker stop `cat .reactiondev.cid`
	-docker rm `cat .reactiondev.cid`
	-rm -f .reactiondev.cid

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
