FROM ekidd/rust-musl-builder:1.42.0 as builder
ADD --chown=rust:rust . ./
RUN cargo build --release

FROM alpine:latest
COPY --from=builder \
    /home/rust/src/target/x86_64-unknown-linux-musl/release/embedit \
    /usr/local/bin/
CMD /usr/local/bin/embedit