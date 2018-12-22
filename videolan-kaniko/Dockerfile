FROM golang:1.10
ENV IMAGE_DATE=201812073506
WORKDIR /go/src/github.com/GoogleContainerTools
RUN git clone https://github.com/GoogleContainerTools/kaniko && cd kaniko && make GOARCH=amd64

FROM alpine:3.8
RUN apk add git bash

FROM scratch
COPY --from=0 /go/src/github.com/GoogleContainerTools/kaniko/out/executor /kaniko/executor
COPY --from=0 /go/src/github.com/GoogleContainerTools/kaniko/files/ca-certificates.crt /kaniko/ssl/certs/
COPY --from=0 /go/src/github.com/GoogleContainerTools/kaniko/files/config.json /kaniko/.docker/
COPY --from=1 / /alpine/
COPY --from=1 /bin/bash /bin/bash
COPY --from=1 /bin/busybox /bin/busybox
COPY --from=1 /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
VOLUME /alpine
ENV HOME /root
ENV USER /root
ENV LD_LIBRARY_PATH /alpine/lib:/alpine/usr/lib/
ENV PATH /usr/local/bin:/kaniko:/alpine/usr/bin:/alpine/usr/sbin:/alpine/bin/:/alpine/sbin
ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/
ENTRYPOINT ["/kaniko/executor"]
