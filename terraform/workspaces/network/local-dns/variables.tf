# declared without type, see type in submodule ubiquiti
# no need to keep overhead of syncing the two vars.
variable "dns_config" {}

variable "adguard_api_user" {
    type = object({
        username  = string
        password  = string
    })
    sensitive = true
    default = null
}
