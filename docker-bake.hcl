variable "VERSION" {
  # renovate: datasource=go depName=github.com/caddyserver/caddy/v2
  default = "v2.9.1"
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
        xcaddy-args = "--with github.com/caddy-dns/he"
        tag-suffix = "he-dns"
      },
      {
        xcaddy-args = "--with github.com/caddy-dns/acmedns"
        tag-suffix = "acme-dns"
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
