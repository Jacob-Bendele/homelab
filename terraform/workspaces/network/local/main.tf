module "home_unifi_network" {
    source="../modules/ubiquiti"
    providers = {
      unifi = unifi
    }

    config = var.network_config
    wifi_passphrases = var.wifi_passphrases
}

module "home_dns" {
  source="../modules/adguard_dns"

  providers = {
    adguard = adguard
  }

  config = var.dns_config
}