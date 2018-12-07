FROM golang:1.10
WORKDIR /go/src/github.com/GoogleContainerTools
RUN git clone https://github.com/GoogleContainerTools/kaniko && cd kaniko && make GOARCH=amd64

FROM debian:stretch-20181112-slim
COPY --from=0 /go/src/github.com/GoogleContainerTools/kaniko/out/executor /kaniko/executor
COPY --from=0 /go/src/github.com/GoogleContainerTools/kaniko/files/ca-certificates.crt /kaniko/ssl/certs/
COPY --from=0 /go/src/github.com/GoogleContainerTools/kaniko/files/config.json /kaniko/.docker/
RUN apt-get update && apt-get install -y --no-install-suggests --no-install-recommends git && apt-get clean -y && rm -rf /var/lib/apt/lists/*
ENV HOME /root
ENV USER /root
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/kaniko
ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/
ENTRYPOINT ["/kaniko/executor"]
