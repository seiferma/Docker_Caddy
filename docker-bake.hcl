variable "VERSION" {
  default = "latest"
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
  tags = ["${trimsuffix("quay.io/seiferma/caddy:${VERSION}-${item.tag-suffix}", "-")}"]
  args = {
    CADDY_VERSION = "${VERSION}",
    XCADDY_ARGS = "${item.xcaddy-args}"
  }
}
