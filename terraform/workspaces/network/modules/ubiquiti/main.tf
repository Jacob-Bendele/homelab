# The default values created by Unifi controller.
data "unifi_network" "default" {
  name = "Default"
}

data "unifi_port_profile" "default" {
  name = "All"
}

data "unifi_ap_group" "default" {
}

data "unifi_user_group" "default" {
}

data "unifi_network" "wan1" {
  name = "Primary (WAN1)"
}

# Configure sitewide DNS
# run an import of the unifi_network wan1 resource
# import 'module.home_unifi_network.unifi_network.wan1' {id}

resource "unifi_network" "wan1" {
  name = "Primary (WAN1)"
  purpose = "wan"
  wan_dns = var.config.dns_servers

  dhcp_dns                     = []
  dhcp_enabled                 = false
  dhcp_lease                   = 0
  dhcp_relay_enabled           = false
  dhcp_v6_dns                  = []
  dhcp_v6_dns_auto             = false
  dhcp_v6_enabled              = false
  dhcp_v6_lease                = 0
  dhcpd_boot_enabled           = false
  igmp_snooping                = false
  internet_access_enabled      = true
  intra_network_access_enabled = true
  ipv6_ra_enable               = false
  ipv6_ra_preferred_lifetime   = 0
  ipv6_ra_valid_lifetime       = 0
  multicast_dns                = false
  site                         = "default"
  vlan_id                      = 0
  wan_egress_qos               = 0
  wan_networkgroup             = "WAN"
  wan_type                     = "dhcp"
  wan_type_v6                  = "disabled"

}

# Take existing unifi hardware (aps, switchets, etc.) take them under terraform management.
resource "unifi_device" "switches" {
  for_each = var.config.switches != null && length(var.config.switches) > 0 ? var.config.switches : {}

  mac = each.key
  name = each.value.name

  dynamic "port_override" {
    for_each = each.value.port_overrides != null ? each.value.port_overrides : {}

    content {
      number = port_override.value.number
      op_mode = port_override.value.op_mode != null ? port_override.value.op_mode : null
      aggregate_num_ports = port_override.value.aggregate_num_ports != null  ? port_override.value.aggregate_num_ports : null
      port_profile_id = lookup(unifi_port_profile.port_profile, port_override.value.port_profile_name, null) != null ? unifi_port_profile.port_profile[port_override.value.port_profile_name].id : data.unifi_port_profile.default.id
    }
  }
}

# Seems to have been a switch in how these are handled. No longer autogenerated when network is made.
# data "unifi_port_profile" "port_profile" {
#   for_each = var.config.vlans != null && length(var.config.vlans) > 0 ? unifi_network.vlan : {}  
  
#   name = each.key
# }


resource "unifi_port_profile" "port_profile" {
  for_each = var.config.vlans != null && length(var.config.vlans) > 0 ? var.config.vlans : {}

  name = each.key
  native_networkconf_id = unifi_network.vlan[each.key].id

}

# Create VLAN networks
resource "unifi_network" "vlan" {
  for_each = var.config.vlans != null && length(var.config.vlans) > 0 ? var.config.vlans : {}
  
  name           = each.key
  purpose        = "corporate"
  vlan_id        = each.value.id
  site           = var.config.site
  subnet         = each.value.subnet
  dhcp_start     = cidrhost(each.value.subnet, 6)
  dhcp_stop      = cidrhost(each.value.subnet, 254)
  dhcp_enabled   = true  

}

# Static IP assignments
data "unifi_user" "client" {
  for_each = var.config.static_ips != null && length(var.config.static_ips) > 0 ? var.config.static_ips : {}
  
  mac = each.key
}

resource "unifi_user" "static_ip" {
  for_each = var.config.static_ips != null && length(var.config.static_ips) > 0 ? var.config.static_ips : {}

  mac         = each.key
  fixed_ip    = each.value.ip
  name        = coalesce(data.unifi_user.client[each.key].hostname, each.value.name)
  network_id  = coalesce(try(unifi_network.vlan[each.value.network].id, null), data.unifi_network.default.id)
  site        = var.config.site
}

# Create WLAN networks

resource "unifi_wlan" "wifi_networks" {
  # for_each = { for idx, network in var.config.wifi_networks : network.ssid => network }
  for_each = var.config.wifi_networks != null && length(var.config.wifi_networks) > 0 ? var.config.wifi_networks : {}

  name           = each.value.ssid
  security       = each.value.security
  passphrase     = sensitive(try(var.wifi_passphrases[each.value.passphrase_key], null))
  network_id     = coalesce(try(unifi_network.vlan[each.value.network_name].id, null), data.unifi_network.default.id)
  ap_group_ids   = coalesce(each.value.ap_group_ids, [data.unifi_ap_group.default.id])
  user_group_id  = coalesce(each.value.user_group_id, data.unifi_user_group.default.id)
  
  wlan_band      = each.value.band
  hide_ssid      = each.value.hide_ssid
  is_guest       = each.value.is_guest

  site = var.config.site
}
