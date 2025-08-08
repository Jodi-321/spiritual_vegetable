# Application GW with WAF
resource "azurerm_public_ip" "appgw" {
    name = "${var.name_prefix}-appgw-pip-${var.location_short}"
    location = var.location
    resource_group_name = var.resource_group_name
    allocation_method = "Static"
    sku = "Standard"

    tags = var.common_tags
}

resource "azurerm_application_gateway" "main" {
    name = "${var.name_prefix}-appgw-${var.location_short}"
    location = var.location
    resource_group_name = var.resource_group_name

    identity {
      type = "UserAssigned"
      identity_ids = [var.appgw_identity_id]
    }

    sku {
        name = "WAF_v2"
        tier = "WAF_v2"
        capacity = 2
    }

    gateway_ip_configuration {
        name = "appgw"
        subnet_id = var.subnet_id
    }

    frontend_port {
        name = "https-port"
        port = 443
    }

    frontend_ip_configuration {
        name = "public-frontend"
        public_ip_address_id = azurerm_public_ip.appgw.id
    }

    ssl_certificate {
        name = "mvp-ssl-cert"
        key_vault_secret_id = azurerm_key_vault_certificate.appgw_cert.secret_id
    }

    backend_address_pool {
        name = "api-backend"
        ip_addresses = [var.api_vm_private_ip]
    }

    backend_address_pool {
      name = "web-backend"
      ip_addresses = [var.web_vm_private_ip]
    }

    backend_http_settings {
      name = "web-http-settings"
      cookie_based_affinity = "Disabled"
      port = 80
      protocol = "Http"
      request_timeout = 30
      pick_host_name_from_backend_address = false
    }

    backend_http_settings {
        name = "api-http-settings"
        cookie_based_affinity = "Disabled"
        port = 8443
        protocol = "Https"
        request_timeout = 30
        pick_host_name_from_backend_address = false
    }

    http_listener {
      name = "https-listener"
      frontend_ip_configuration_name = "public-frontend"
      frontend_port_name = "https-port"
      protocol = "Https"
      ssl_certificate_name = "mvp-ssl-cert"
    }

    request_routing_rule {
      name = "main-route"
      rule_type = "PathBasedRouting"
      priority = 100
      http_listener_name = "https-listener"
      url_path_map_name = "main-path-map"
    }

    url_path_map {
        name = "main-path-map"
        default_backend_address_pool_name = "web-backend"
        default_backend_http_settings_name = "web-http-settings"

        path_rule {
            name = "api-path"
            paths = ["/api/*"]
            backend_address_pool_name = "api-backend"
            backend_http_settings_name = "api-http-settings"
        }
    }

    waf_configuration {
        enabled = true
        firewall_mode = "Prevention"
        rule_set_type = "OWASP"
        rule_set_version = "3.2"
    }

    tags = var.common_tags
}