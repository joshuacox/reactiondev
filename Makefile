TAG:=joshuacox/reactiondev

all: build run ps

build:
	docker build -t $(TAG) .

pull:
	docker pull $(TAG)

run: .reactiondev.cid

.reactiondev.cid: PORT
	$(eval PORT := $(shell cat PORT))
	docker run --name reactiondev \
		-d \
		-p $(PORT):3000 \
		--cidfile=.reactiondev.cid \
		-v $(HOME):/home/node \
		joshuacox/reactiondev

demo:
	docker run --name reactiondev \
		-d \
		-p 3003:3000 \
		--cidfile=.reactiondev.cid \
		joshuacox/reactiondev

enter:
	docker exec -it \
		`cat .reactiondev.cid` \
		/bin/bash

logs:
	docker logs -f `cat .reactiondev.cid`

clean:
	docker stop `cat .reactiondev.cid`
	docker rm `cat .reactiondev.cid`
	rm -f .reactiondev.cid

ps:
	-@sleep 2
	docker ps|grep reactiondev

PORT:
	@while [ -z "$$PORT" ]; do \
		read -r -p "Enter the port you wish to associate with this container [PORT]: " PORT; echo "$$PORT">>PORT; cat PORT; \
	done ;
