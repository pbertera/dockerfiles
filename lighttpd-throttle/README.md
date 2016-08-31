Simple [lighttpd](https://www.lighttpd.net/) Docker container working as a proxy or server with bandwidth throttling:

```
$ docker run -it pbertera/lighttpd-throttle help
This container can be configured trough the following env. variables:

* LIGHTTPD_PROXY: if set lighttpd is configured in Proxy mode, the following env. variables are required:
  * LIGHTTPD_PROXY_HOST: the host that you want to proxy
  * LIGHTTPD_PROXY_PORT: the port of the proxied host
  * LIGHTTPD_PORT: the listeing port

if LIGHTTPD_PROXY isn't defined lighttpd is configred to serve the /var/www folder.
You can also define the variable LIGHTTPD_THROTTLE representing the max bandwitdh expressed in KB
```

## Eamples

#### Proxy mode:

The following command runs the container listening on the local port `8080` proxying the host `172.16.18.1` port `80`

```
docker run -it -p 8080:8080 \ # expose the port
    -e LIGHTTPD_PROXY=yes \ # act as a proxy
    -e LIGHTTPD_PORT=8080 \ # define the lighttpd port
    -e LIGHTTPD_THROTTLE=100 \ # limit the bandwidth to 100 KB
    -e LIGHTTPD_PROXY_HOST=172.16.18.1 \ # the remote host
    -e LIGHTTPD_PROXY_PORT=80 \ # the remote prot
    pbertera/lighttpd-throttle
```

#### Server mode:

This command serves the current directory over the port `8080`with 100KB of max bandwidth

```
docker run -it -p 8080:8080 \ # expose the port
    -e LIGHTTPD_PORT=8080 \ # define the lighttpd port
    -e LIGHTTPD_THROTTLE=100 \ # limit the bandwidth to 100 KB
    -v $(pwd):/var/www \ # mount the local folder into the document root
    pbertera/lighttpd-throttle
```
