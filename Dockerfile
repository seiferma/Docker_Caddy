FROM --platform=$BUILDPLATFORM golang:1.24-alpine@sha256:7772cb5322baa875edd74705556d08f0eeca7b9c4b5367754ce3f2f00041ccee AS builder

ARG TARGETARCH
ARG GOOS=linux
ARG CGOENABLED=0
ARG CADDY_VERSION=
ARG XCADDY_ARGS=
# renovate: datasource=go depName=github.com/caddyserver/certmagic
ARG CERTMAGIC_VERSION=v0.22.2

RUN apk add --no-cache git
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
RUN export GOARCH=$TARGETARCH && \
    xcaddy build $CADDY_VERSION \
      --replace github.com/caddyserver/certmagic=github.com/caddyserver/certmagic@$CERTMAGIC_VERSION \
      $XCADDY_ARGS
RUN apk add --no-cache libcap
RUN setcap cap_net_bind_service=+ep /go/caddy
RUN touch /tmp/empty



FROM scratch

ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

COPY --from=builder /tmp/empty /etc/caddy/Caddyfile
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/caddy /bin/caddy

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]