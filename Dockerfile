FROM alpine:latest as chown
COPY ./* /project/
RUN chown -R 1000:1000 /project

FROM ekidd/rust-musl-builder:1.44.0 as build
COPY --from=chown /project/ /home/rust/src/
WORKDIR /home/rust/src/project
RUN cargo build --release

FROM alpine:latest
COPY --from=build /project/target/release/embedit /usr/local/bin/embedit
CMD embedit