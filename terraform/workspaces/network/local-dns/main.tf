
module "home_dns" {
  source = "../modules/adguard_dns"

  providers = {
    adguard = adguard
  }

  config = var.dns_config
}

# Resolve the single-label name directly for VPN clients, and its search-domain
# expansion for LAN clients. The go-links ingress upgrades both to the
# canonical HTTPS hostname.
resource "adguard_rewrite" "go_single_label" {
  domain = "go"
  answer = "192.168.100.10"
}

resource "adguard_rewrite" "go_home_arpa" {
  domain = "go.home.arpa"
  answer = "192.168.100.10"
}
