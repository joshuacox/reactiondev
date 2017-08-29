# reactiondev

A simple dockerized [reaction commerce](https://reactioncommerce.com/) dev environment

### Usage

`make build` to build it

`make run` to run it

`make logs` and follow the logs, ctrl-C to stop watching the logs

`make enter` to go into the dev environment, which should also be on http://localhost:3000 

while inside you should have your ssh keys mounted in, so you can do things like `git remote add mycustomreaction git@github.com:githhubuser/mycustomreaction` so you can push any changes you make.
