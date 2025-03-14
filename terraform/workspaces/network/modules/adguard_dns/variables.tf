variable "config" {
    type = object({
        upstream_dns = list(string)
        fallback_dns = list(string)
        local_redirects = map(object({
            domain = string
            address = string
        }))
    })
}
