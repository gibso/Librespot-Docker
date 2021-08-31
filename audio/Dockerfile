FROM ubuntu:20.04

RUN apt-get update && apt-get install -yq pulseaudio

RUN useradd -ms /bin/bash pulseuser
USER pulseuser

# run pulseaudio once daemonized to generate the config files
RUN pulseaudio -D

CMD [ "pulseaudio" ]
