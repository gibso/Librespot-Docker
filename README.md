# Librespot Docker

This is a dockerized [librespot](https://github.com/librespot-org/librespot) application, built with the pulseaudio-backend.

## Configure Audio

To enable audio support for a container of this image you can use your host pulse audio server as a remote server for the container.
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