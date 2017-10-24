### Scripts

This scripts folder is meant for local tasks like the cleanup
of the TMP directories, running the demos, and other tags, it
spawned from cmd which was a simple way for me to invert arguments into
environment variables for the Makefile. Based on the second answer
[here](https://stackoverflow.com/questions/6273608/how-to-pass-argument-to-makefile-from-command-line)
the first seems a bit ugly to me and prone to mishaps

And was how I refactored the makefile from having tons of duplicates,
sort of an external function.  I gladly accept discussion and PRs.

### cmd

there is a symlink above try

```
./cmd reaction test
```

The above ought to be equivalent to the `make test` command

### build

```
./build mycustom
```

will result in reaction build mycustom

### demo

No symlink yet for this one so let's call it like the Makefile does

```
./scripts/demo joshuacox/reactiondev:demo 3101
```

### tagged

Like `demo` you call the tag you want, the difference is that here you
will be prompted to set `PORT` and `REACTION_ROOT` if you have not
already

```
./scripts/tagged joshuacox/reactiondev:node-8
```

### rmdirs

go through `.tmplist` and remove all temporary dirs
