# reactiondev

  A simple dockerized [reaction commerce](https://reactioncommerce.com/) dev environment, i use many flavors of linux on the same laptop, this gives me a consistent way of starting node to view my edits across them all.


### Demo

For a ephemeral demo instance that will not retain data, and let you
play around with a default Reaction demo

`docker pull joshuacox/reactiondev:demo`  and then run it with something like

```
	docker run --name reactiondevdemo -d -p 3001:3000 joshuacox/reactiondev:demo
```

### Usage

I'm using it to test out local reaction development directories as such:

`docker pull joshuacox/reactiondev`  and then run it with something like

```
docker run --name reactiondev -d \
  -p 3002:3000 \
  -v $(REACTION_ROOT):/home/node/reaction \
  joshuacox/reactiondev
```

and point your browser to
[http://localhost:3002](http://localhost:3002)

### Makefile

A makefile is included in the git repo because I'm a lazy typist

`make build` to build it

`make demo` to run an ephemeral instance for demo purposes (everything
will be blown away when it is stopped)

`make run` to run it with your local checked out copy of reaction that
you are modifying live, you will be prompted for the path to this
reaction directory and the port number you wish to use, after which it will save this location

Your reaction will be availble at http://localhost:PORT where port is
the one you chose above when you were prompted

Note: to reset the answers to those questions just edit them or
`rm REACTION_ROOT` or `rm PORT`
and you will be prompted again, these files are ignored by git

`make logs` and follow the logs, ctrl-C to stop watching the logs

`make enter` to go into the dev environment

`make clean` will stop and remove the container

#### Alternatives

You can also use [NVM](https://github.com/creationix/nvm) and many other
ways of managing node versions, this is just one.
