# Docker container for Deadwood DNS resolver

This container clones the Deadwood github repository and runs deadwood.

You can pass a customised deadwood RC file mounting a volume over the `/opt/deadwood/dwoodrc.tpl`.

`dwoodrc.tpl` file can contain some variables that will be substituted at startup time.

### Example:

#### Build:

`docker build -t pbertera/deadwood`

#### Run:

`docker run -it -p 53:53/udp pbertera/deadwood`

### Run with a cusom dwoodrc.tpl

1. modify the dwoodrc.tpl with `upstream_servers["."]="$UPSTREAM_SERVER"`
2. run the container with the volume and the env variable:

    `docker run -it -p 53:53/udp -e "UPSTREAM_SERVER=8.8.8.8" -v $PWD/dwoodrc.tpl:/opt/deadwood/dwoodrc.tpl pbertera/deadwood`
