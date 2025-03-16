terraform {
  required_providers {
    unifi = {
      source  = "paultyng/unifi"
      version = "0.41.0"
    }
  }
}

provider "unifi" {
  allow_insecure = true
  api_url  = var.network_config.unifi_host
  username = var.unifi_api_user.username
  password = var.unifi_api_user.password
}
