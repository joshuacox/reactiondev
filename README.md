# reactiondev

A simple dockerized [reaction commerce](https://reactioncommerce.com/) dev environment

### Usage

`docker pull joshuacox/reactiondev`  and then run it with something like

```
docker run --name reactiondev \
	-d \
	-p 3000:3000 \
	--cidfile=.reactiondev.cid \
	-v $(HOME)/.ssh:/home/reaction/.ssh \
	joshuacox/reactiondev
```

### Makefile

A makefile is included in the git repo because I'm a lazy typist

`make build` to build it

`make run` to run it

`make logs` and follow the logs, ctrl-C to stop watching the logs

`make enter` to go into the dev environment, which should also be on http://localhost:3000 

while inside you should have your ssh keys mounted in, so you can do things like `git remote add mycustomreaction git@github.com:githhubuser/mycustomreaction` so you can push any changes you make.

`make clean` will stop and remove the container
