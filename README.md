# reactiondev

  A simple dockerized [reaction commerce](https://reactioncommerce.com/) dev environment, i use many flavors of linux on the same laptop, this gives me a consistent way of starting node to view my edits across them all.

---

### Demo

For an ephemeral demo instance that will not retain data, and let you
play around with a default Reaction demo

run it with:

```
docker run -p 3001:3000 joshuacox/reactiondev:demo
```

and you'll find it on [localhost:3001](http://localhost:3001/)

---

### Usage

I'm using it to test out local reaction development directories as such:

`docker pull joshuacox/reactiondev`  and then run it with something like

```
docker run --name reactiondev -d \
  -p 3002:3000 \
  -v $(REACTION_ROOT):/home/node/reaction \
  joshuacox/reactiondev
```

or pass in your own reaction command:

```
docker run --name reactiondev -d \
  -p 3002:3000 \
  -v $(REACTION_ROOT):/home/node/reaction \
  joshuacox/reactiondev \
  reaction test
```

or meteor command:
```
docker run --name reactiondev -d \
  -p 3002:3000 \
  -v $(REACTION_ROOT):/home/node/reaction \
  joshuacox/reactiondev \
  meteor npm i
```

or login and do it yourself:
```
docker exec -it \
  $REACTIODEV_CONTAINER_ID
  /bin/bash
```

   Where $REACTIODEV_CONTAINER_ID is the container ID of reactiondev
`docker ps|grep reactiondev|awk '{print $1}'`

Or use my makefile below with `make enter`, which exploits the
`--cidfile` option for `docker run`.

and point your browser to
[http://localhost:3002](http://localhost:3002)

---

### Demo Tags

There are a few demo tags available which correspond to being demo's of that
particular verison of Reaction Commerce and the marketplace, merely do a
`reaction init -b TAG` when building

```
v1.5.8
v1.5.7
v1.5.6
v1.5.5
v1.5.4
v1.5.3
v1.5.2
v1.5.1
v1.5.0
v1.4.3
v1.4.2
v1.4.1
v1.4.0
v1.3.0
```

example:
```
docker run --name reactiondevdemo -d -p 3001:3000 joshuacox/reactiondev:v1.4.0
```

---

### Branches

Also available in dockerhub as tags, I have a few branches that relate to the
alpine, different node versions, and experimental builds, notably:

```
node-8
node-boron
node-argon
node-slim
node-stretch
node-wheezy
```

Of note, these are different than the demo tags section above in that they
are intended to have a mounted reaction directory, e.g.

```
docker run --name reactiondevdemo -d \
  -p 3001:3000 \
  -v $(REACTION_ROOT):/home/node/reaction \
  joshuacox/reactiondev:node-slim
```

### Special Branches

```
strace
```

strace will allow you to strace the whole reaction process, you will be
prompted for strace options beforehand the example is (include the
quotes):


```
'-T -ttt -ff -o /tmp/strace/strace.out'
```

---

### Environment variables

`REACTION_ROOT`  inside the container this by default will point to
`/home/node/reaction` you can point it to whereever you want and change
your corresponding volume mount e.g.

```sh
docker run --name reactiondev -d \
  -p 3002:3000 \
  -e REACTION_ROOT=/opt/reaction \
  -v $(REACTION_ROOT):/opt/reaction \
  joshuacox/reactiondev
```

---

### Scripts
---

##### cmd

Using `./cmd` you can run anything you like
inside the container. e.g.

`./cmd echo hello world`

##### build

`./build IMAGE_NAME` will run `sudo reaction build IMAGE_NAME` inside the
container, but use your local docker to build the custom reaction build.
e.g.

`./build mycustom`

`docker images mycustom` afterwards to see your image

There are other scripts in the `scripts` directory, which contains it's
own readme.


### Makefile

A makefile is included in the git repo because I'm a lazy typist.

`make pull` to pull it

`make` to run it with your local checked out copy of reaction that
you are modifying live, you will be prompted for the path to this
reaction directory and the port number you wish to use, after which it will save this location

Your reaction will be availble at http://localhost:PORT where port is
the one you chose above when you were prompted

Note: to reset the answers to those questions just edit them or
`rm REACTION_ROOT` or `rm PORT`
and you will be prompted again, these files are ignored by git

`make demo` to run an ephemeral instance for demo purposes (everything
will be blown away when it is stopped)

`make test` will run the container with `reaction test` as the initial
command upon startup

`make i` will run the container with `meteor npm i` as the initial
command upon startup

`make logs` and follow the logs, ctrl-C to stop watching the logs

`make enter` to go into the dev environment

`make clean` will stop and remove the container

`make demos` to run many ephemeral instances for demo purposes (everything
will be blown away when they are stopped) caution this will download
many demos at once and run them all on ports above 3100!

`make localbuild` to build the reactiondev image locally it

`make fresh` will clone a fresh copy of reaction into tmp and build from
there

there are also various branches you can test easily with the makefile:

```
make node-8
make node-8.4
make node-argon
make node-boron
make node-slim
make node-stretch
make node-wheezy
```

and the demos

```
make v141
make v140
make v130
```

---

#### Alternatives

You can also use [NVM](https://github.com/creationix/nvm) and many other
ways of managing node versions, this is just one.

---
