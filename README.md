# mkarduino

This makefile nets you a dockerized arduino application.  I made this as
I am using Arch Linux with
the community AUR packages , which were giving me issues awhile back
(usually problems with newer javas being released on arch).  Now that
it's in docker I have not had an issue since.

## Branches

### `built` using dockerhub

If you do not want to build locally checkout the [built
branch](https://github.com/joshuacox/mkarduino/tree/built)

```
git checkout built
```

### `stretch-gui`

This is what master is following at the moment, and hence is what
dockerhub uses to build the image that the `built` branch pulls.
It uses debian stretch as a base, installs dependencies and then
installs the nightly arduino IDE

### Others

Most of the other branches are not maintained at the moment as I am not
using them, I gladly accept pull requests, and will certainly fix
anything within reason, but I recommend you start with the built branch
as it will most likely be the fastest way to test it out.

### Usage

`make` 

This will prompt you for your sketchbook directory (usually
`~/sketchbook`, and sometimes `~/Arduino`). And a `git` directory, which
is where most of my code lives, but you can feed it any directory and it
will be mounted in your arduino environment. It will then create an
Xauthority file and boot an arduino IDE for you to program arduinos.

#### Enter

`make enter` - This will get you a bash shell inside the running container

#### Logs 

`make logs` - This will show you the logs of the running container

#### Help

`make help`  - This will print some useless information
