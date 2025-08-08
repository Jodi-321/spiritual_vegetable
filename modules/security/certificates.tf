# Certificates for the MVP
resource "azurerm_key_vault_certificate" "appgw_cert" {
    name = "appgw-zt-cert"
    key_vault_id = azurerm_key_vault.main.id

    certificate_policy {
        issuer_parameters {
            name = "Self"
        }
    

        key_properties {
            exportable = true
            key_size = 2048
            key_type = "RSA"
            reuse_key = true
        }

        secret_properties {
            content_type = "application/x-pkcs12"
        }

        x509_certificate_properties {
            subject = "CN=appgw-zt-mvp.local"
            validity_in_months = 12
            key_usage = [
                "digitalSignature",
                "keyEncipherment",
                "dataEncipherment"
            ]
        }
    
    }

    lifecycle {
      create_before_destroy = true
    }

    tags = var.common_tags
}

