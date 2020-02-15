# Cloudflared in Docker

[![Docker multi-arch build](https://github.com/zmingxie/dockerfile-cloudflared/workflows/docker-buildx-push/badge.svg?branch=master&event=push)](https://github.com/zmingxie/dockerfile-cloudflared/actions?query=workflow%3Adocker-buildx-push)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Docker Pulls](https://img.shields.io/docker/pulls/mxie/cloudflared.svg)](https://hub.docker.com/r/mxie/cloudflared/)
[![Docker Tag](https://images.microbadger.com/badges/version/mxie/cloudflared.svg)](https://microbadger.com/images/mxie/cloudflared)
[![Docker Layers](https://images.microbadger.com/badges/image/mxie/cloudflared:latest.svg)](https://microbadger.com/images/mxie/cloudlared)

(Forked from [upstream](https://github.com/visibilityspots/dockerfile-cloudflared) and modified to use Github Action for releases)

A docker container which runs the [cloudflared](https://developers.cloudflare.com/1.1.1.1/dns-over-https/cloudflared-proxy/) proxy-dns at port 5054 based on alpine with some parameters to enable DNS over HTTPS proxy for [pi-hole](https://pi-hole.net/) based on tutorials from [Oliver Hough](https://oliverhough.cloud/blog/configure-pihole-with-dns-over-https/) and [Scott Helme](https://scotthelme.co.uk/securing-dns-across-all-of-my-devices-with-pihole-dns-over-https-1-1-1-1/)

## Run

```bash
docker run --name cloudflared --rm --net host mxie/cloudflared
```

### custom upstream DNS

```bash
docker run --name cloudflared --rm --net host -e DNS1=x.x.x.x -e DNS2=x.x.x.x mxie/cloudflared
```

### docker-compose

```yaml
version: "3"

services:
  cloudflared:
    container_name: cloudflared
    image: mxie/cloudflared:latest
    restart: unless-stopped
    # networks config is optional
    networks:
      pihole_net:
        ipv4_address: 10.0.0.2
```

## Test

I wrote some tests in a [goss.yaml](./goss.yaml) file which can be executed by [dgoss](https://github.com/aelsabbahy/goss/tree/master/extras/dgoss)

```
$ dgoss run --name cloudflared --rm -ti mxie/cloudflared:latest
INFO: Starting docker container
INFO: Container ID: e5bd35d3
INFO: Sleeping for 0.2
INFO: Running Tests
Process: cloudflared: running: matches expectation: [true]
Package: ca-certificates: installed: matches expectation: [true]
Command: cloudflared --version | head -1: exit-status: matches expectation: [0]
Command: cloudflared --version | head -1: stdout: matches expectation: [cloudflared version DEV (built unknown)]


Total Duration: 0.028s
Count: 4, Failed: 0, Skipped: 0
INFO: Deleting container
```

## License
Distributed under the MIT license
