
module "home_dns" {
  source="../modules/adguard_dns"

  providers = {
    adguard = adguard
  }

  config = var.dns_config
}