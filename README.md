# Librespot Docker

This is a dockerized [librespot](https://github.com/librespot-org/librespot) application, built with the pulseaudio-backend.

## Running Librespot

You can run the docker container either by

```bash
$ docker run --device /dev/snd -v ~/.config/pulse/cookie:/home/librespot/.pulse-cookie -e PULSE_SERVER=172.17.0.1 librespot
```
or by using this preconfigured [`docker-compose.yml`](docker-compose.yml)
```bash
$ docker-compose run librespot
```

You can add the [librespot options](https://github.com/librespot-org/librespot/wiki/Options) to both run commands, like
```bash
$ docker-compose run librespot --name my-librespot-instance
```

## Building Image

Build this image by running either

```bash
$ docker build -t librespot .
```

or, if you prefer docker-compose

```
$ docker-compose build
```

## Configure Audio

To enable audio support for a container of this image you can use your host pulse audio server as a remote server for the librespot container.
In your container you have to
* mount the sound card as a device
* mount the pulse authentication cookie
* set the host as remote pulse server via environment variable

```yml
    devices:
      - /dev/snd:/dev/snd
    volumes:
      - ~/.config/pulse/cookie:/home/kodi/.pulse-cookie
    environment:
      PULSE_SERVER: 172.17.0.1
```

Beware that `172.17.0.1` is the static ip of your host in your docker network on linux systems.
Take a look at the [`docker-compose.yml`](docker-compose.yml) for an example configuration.

On your host you need to allow the connection of Pulse clients via TCP with:
```bash
$ pactl load-module module-native-protocol-tcp
```
but you have to reload the module after a reboot. To load the module permanently you have to activate the corresponding line in the file `/etc/pulse/default.pa`.
``` bash
### Network access (may be configured with paprefs, so leave this commented
### here if you plan to use paprefs)
#load-module module-esound-protocol-tcp
load-module module-native-protocol-tcp
#load-module module-zeroconf-publish
```

## Networking

To make Librespot discoverable from you hosts network, you need to configure the container to use the "host" network-mode. Beware that the PULSE_SERVER variable changes to `127.0.0.1` in that setting.

```yml
    devices:
      - /dev/snd:/dev/snd
    network_mode: host
    volumes:
      - ~/.config/pulse/cookie:/home/kodi/.pulse-cookie
    environment:
      PULSE_SERVER: 127.0.0.1
```