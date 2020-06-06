FROM ekidd/rust-musl-builder:1.42.0 as builder
ADD --chown=1000:1000 . ./
RUN cargo build --release

FROM alpine:latest
COPY --from=builder \
    /home/rust/src/target/x86_64-unknown-linux-musl/release/embedit \
    /usr/local/bin/
CMD /usr/local/bin/embedit