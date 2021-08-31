FROM alpine/git AS git

WORKDIR /librespot

RUN git clone --depth 1 --branch master https://github.com/librespot-org/librespot.git .

FROM rust as build-env

RUN apt-get update && apt-get install -y libpulse-dev

WORKDIR /app

COPY --from=git /librespot .

RUN cargo build --release --no-default-features --features pulseaudio-backend

FROM ubuntu:20.04

RUN apt-get update && apt-get install -y libpulse0 libasound2 libasound2-plugins

COPY --from=build-env /app/target/release/librespot /usr/bin/librespot

RUN apt-get install -y pulseaudio

RUN useradd -ms /bin/bash librespot
USER librespot

CMD /usr/bin/librespot

# RUN apk add --no-cache pulseaudio pulseaudio-alsa alsa-plugins-pulse

# # WORKDIR /opt/app

# COPY --from=builder /home/rust/src/target/x86_64-unknown-linux-musl/release/librespot /usr/bin/librespot

# CMD ["/usr/local/bin/librespot"]

# FROM debian


# WORKDIR /opt/app

# RUN apt-get update && apt-get install -y libpulse0 libasound2 libasound2-plugins

# COPY --from=builder /build/release .

# RUN useradd -ms /bin/bash librespot
# USER librespot

# ENTRYPOINT [ "/opt/app/librespot" ]
