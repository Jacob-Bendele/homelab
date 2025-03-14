resource "adguard_config" "home_config" {
    dns = {
        upstream_dns = var.config.upstream_dns
        fallback_dns = var.config.fallback_dns
    }
}

resource "adguard_rewrite" "dns_redirects" {
    for_each = var.config.local_redirects != null && length(var.config.local_redirects) > 0 ? var.config.local_redirects : {}

    answer = each.value.address
    domain = each.value.domain
}