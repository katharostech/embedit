FROM ekidd/rust-musl-builder:1.44.0 as build

COPY . /project
WORKDIR /project
RUN cargo build --release

FROM alpine:latest

COPY --from /project/target/release/embedit /usr/local/bin/embedit
CMD embedit