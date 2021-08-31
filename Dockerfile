FROM alpine/git AS git

WORKDIR /librespot

RUN git clone --depth 1 --branch master https://github.com/librespot-org/librespot.git .

FROM rust as build-env

RUN apt-get update && apt-get install -y libpulse-dev

WORKDIR /app

COPY --from=git /librespot .

RUN cargo build --release --no-default-features --features pulseaudio-backend

FROM bitnami/minideb:latest

RUN apt-get update && apt-get install -y libpulse0

COPY --from=build-env /app/target/release/librespot /usr/bin/librespot

RUN useradd -ms /bin/bash librespot
USER librespot

CMD /usr/bin/librespot
