variable "VERSION" {
  # renovate: datasource=go depName=github.com/caddyserver/caddy/v2
  default = "v2.11.2"
}

target "default" {
  name = "default-${item.tag-suffix}"
  matrix = {
    item = [
      {
        xcaddy-args = ""
        tag-suffix = ""
      },
      {
        xcaddy-args = "--with github.com/caddy-dns/acmedns"
        tag-suffix = "acme-dns"
      },
      {
        xcaddy-args = "--with github.com/hslatman/caddy-crowdsec-bouncer/http --with github.com/hslatman/caddy-crowdsec-bouncer/layer4 --with github.com/hslatman/caddy-crowdsec-bouncer/appsec"
        tag-suffix = "crowdsec"
      }
    ]
  }
  platforms = ["linux/amd64", "linux/arm64"]
  tags = [
    "${trimsuffix("quay.io/seiferma/caddy:${VERSION}-${item.tag-suffix}", "-")}",
    "${trimsuffix("quay.io/seiferma/caddy:latest-${item.tag-suffix}", "-")}"
  ]
  args = {
    CADDY_VERSION = "${VERSION}",
    XCADDY_ARGS = "${item.xcaddy-args}"
  }
}
