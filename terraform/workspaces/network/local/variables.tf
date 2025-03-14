# declared without type, see type in submodule ubiquiti
# no need to keep overhead of syncing the two vars.
variable "network_config" {}
variable "dns_config" {}

variable "unifi_api_user" {
    type = object({
        username  = string
        password  = string
    })
    sensitive = true
    default = null
}

variable "adguard_api_user" {
    type = object({
        username  = string
        password  = string
    })
    sensitive = true
    default = null
}

# Network passphrases
variable "wifi_passphrases" {
  type = map(string)
  description = <<EOT
    Map of client wifi passphrases.
    Example: 
    {
      "network_name" = "passphrase"
    }
  EOT
  sensitive = true
  default = null
}
