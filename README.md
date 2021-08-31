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
On your host you need to allow the connection of Pulse clients via TCP with:
```bash
$ pactl load-module module-native-protocol-tcp
```
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
