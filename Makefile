TAG:=joshuacox/reactiondev

all: build run logs

build:
	docker build -t $(TAG) .

run: .reactiondev.cid

.reactiondev.cid:
	docker run --name reactiondev \
		-p 3000:3000 \
		--cidfile=.reactiondev.cid \
		-v $(HOME)/.ssh:/home/reaction/.ssh \
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
