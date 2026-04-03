FROM alpine:3.23
RUN apk add --no-cache openssl
WORKDIR /setup
COPY ./tools/run.sh ./
ENTRYPOINT [ "./run.sh" ]