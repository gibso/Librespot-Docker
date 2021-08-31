

FROM ekidd/rust-musl-builder AS builder

WORKDIR /opt/app

ADD --chown=rust:rust librespot ./

RUN cargo build --release --no-default-features --features pulseaudio-backend


FROM debian

WORKDIR /opt/app

RUN apt-get update && apt-get install -y libpulse0 libasound2 libasound2-plugins

COPY --from=builder /build/release .

RUN useradd -ms /bin/bash librespot
USER librespot

ENTRYPOINT [ "/opt/app/librespot" ]
