FROM golang:alpine AS builder

ENV CLOUDFLARED_VERSION 2020.2.0

RUN apk update && apk add build-base;
RUN cd /go/src && \
    wget https://github.com/cloudflare/cloudflared/archive/${CLOUDFLARED_VERSION}.tar.gz \
    && tar xzf ${CLOUDFLARED_VERSION}.tar.gz
WORKDIR /go/src/cloudflared-${CLOUDFLARED_VERSION}/cmd/cloudflared
RUN go build -o /go/bin/cloudflared


FROM alpine

ENV DNS1 1.1.1.1
ENV DNS2 1.0.0.1

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/main' > /etc/apk/repositories ; \
    echo 'http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories; \
    adduser -S cloudflared; \
    apk add --no-cache ca-certificates bind-tools; \
    rm -rf /var/cache/apk/*;

COPY --from=builder /go/bin/cloudflared /usr/local/bin/cloudflared
HEALTHCHECK --interval=5s --timeout=3s --start-period=5s CMD nslookup -po=5054 cloudflare.com 127.0.0.1 || exit 1

USER cloudflared

CMD ["/bin/sh", "-c", "/usr/local/bin/cloudflared proxy-dns --address 0.0.0.0 --port 5054 --upstream https://${DNS1}/.well-known/dns-query --upstream https://${DNS2}/.well-known/dns-query"]
