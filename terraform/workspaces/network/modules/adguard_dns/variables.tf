variable "config" {
    type = object({
        upstream_dns = list(string)
        fallback_dns = list(string)
        local_redirects = map(object({
            domain = string
            address = string
        }))
        tls = object({
            enabled = bool
            server_name = string
            certificate_chain = string
            private_key = string
        })
    })
}
