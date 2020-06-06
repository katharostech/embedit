FROM ekidd/rust-musl-builder:1.44.0 as build

COPY . /tmp/project
WORKDIR /tmp/project
RUN cargo build --release

FROM alpine:latest

COPY --from=build /project/target/release/embedit /usr/local/bin/embedit
CMD embedit