variable "config" {
  description = "Complete network configuration object"
  type = object({
    unifi_host  = string
    site        = string
    dns_servers = list(string)
    
    vlans = optional(map(object({
      id     = number
      subnet = string
    })))

    switches = optional(map(object({
      mac = string
      name = string
      port_overrides = optional(map(object({
        number = number
        op_mode = optional(string)
        aggregate_num_ports = optional(number)
        port_profile_name = string
      })))
    })))

    port_profiles = optional(map(object({
      native_networkconf_id = optional(string)
      tagged_networkconf_ids = optional(list(string))
    })))
    
    static_ips = optional(map(object({
      network = string
      ip      = string
      name    = string
    })))

    wifi_networks = optional(map(object({
      ssid          = string
      security      = string
      passphrase_key    = optional(string)
      network_name  = string
      band          = string
      hide_ssid     = bool
      is_guest      = bool
      ap_group_ids  = list(string)
      user_group_id = string
    })))
  })
  default = null
  # default = {
  #   site        = "default"
  #   dns_servers = ["9.9.9.9"] # Default Quad9 DNS

  #   vlans = {
  #     servers    = { id = 10, subnet = "192.168.10.0/24" }
  #     iot        = { id = 20, subnet = "192.168.20.0/24" }
  #     general    = { id = 30, subnet = "192.168.30.0/24" }
  #     security   = { id = 40, subnet = "192.168.40.0/24" }
  #     management = { id = 50, subnet = "192.168.50.0/24" }
  #   }

  #   static_ips = {
  #     "aa:bb:cc:dd:ee:01" = { network = "LAN", ip = "192.168.10.100", name = "Device1" }
  #     "aa:bb:cc:dd:ee:02" = { network = "Guest", ip = "192.168.20.101", name = "Device2" }
  #   }

  #   wifi_networks = [
  #     {
  #       ssid          = "MainNetwork"
  #       ap_group_ids  = ["group1", "group2"]
  #       user_group_id = "regular_users"
  #       security      = "wpa-psk"
  #       passphrase    = sensitive("strongPassword123")
  #       network_name  = "MainNetwork"
  #       band          = "both"
  #       hide_ssid     = false
  #       is_guest      = false
  #     }
  #   ]
  # }
}

# Declared outside of config for better secrets handling
variable "wifi_passphrases" {
  type = map(string)
  sensitive = true
  description = "Map of ssid to wifi netwokrs passphrase"
  default = null
 
}
