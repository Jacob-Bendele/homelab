terraform {
  required_providers {
    unifi = {
      source  = "paultyng/unifi"
      version = "0.41.0"
    }
    adguard = {
      source = "gmichels/adguard"
      version = "1.5.0"
    }
  }
}

provider "unifi" {
  allow_insecure = true
  api_url  = var.network_config.unifi_host
  username = var.unifi_api_user.username
  password = var.unifi_api_user.password
}

provider "adguard" {
  host     = var.network_config.static_ips["d8:3a:dd:21:de:83"].ip
  username = var.adguard_api_user.username
  password = var.adguard_api_user.password
  scheme   = "http" # defaults to https
  timeout  = 5      # in seconds, defaults to 10
  insecure = false  # when `true` will skip TLS validation
}
