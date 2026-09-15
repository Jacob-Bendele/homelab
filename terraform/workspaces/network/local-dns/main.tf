
module "home_dns" {
  source = "../modules/adguard_dns"

  providers = {
    adguard = adguard
  }

  config = var.dns_config
}

# LAN clients receive home.arpa as their DNS search domain. This one rewrite
# lets a request for the single-label hostname `go` resolve to Traefik; the
# go-links ingress then upgrades it to the canonical HTTPS hostname.
resource "adguard_rewrite" "go_home_arpa" {
  domain = "go.home.arpa"
  answer = "192.168.100.10"
}
