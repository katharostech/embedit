FROM alpine:latest as chown
COPY ./* /project/
RUN chown -R 1000:1000 /project

FROM ekidd/rust-musl-builder:1.44.0 as build
COPY --from=chown /project/ /home/rust/src/
WORKDIR /home/rust/src/project
RUN cargo build --release && rm -rf target/

FROM alpine:latest
COPY --from=build /home/rust/src/project/target/x86_64-unknown-linux-musl/release/embedit /usr/local/bin/embedit
CMD embedit