########### HTTPS Enforcement #############
resource "azurerm_resource_group_policy_assignment" "baseline" {
  name = "baseline-policy"
  resource_group_id = var.resource_group_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a4af4a39-4135-47fb-b175-47fbdf85311d"
  display_name = var.display_name
  description = var.description
  enforce = true
}

############ Key Vault Security Policies ###############
resource "azurerm_resource_group_policy_assignment" "key_vault_purge_protection" {
    name = "keyvault-purge-protection"
    resource_group_id = var.resource_group_id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0b60c0b2-2dc2-4e1c-b5c9-abbed971de53"
    display_name = "Key Vault Deletion Protection Required"
    description = "Ensures Key Vaults have deletion protection enabled for Zero Trust data protection"
    enforce = true
}

resource "azurerm_resource_group_policy_assignment" "key_vault_firewall" {
    name = "keyvault-firewall-enabled"
    resource_group_id = var.resource_group_id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/55615ac9-af46-4a59-874e-391cc3dfb490"
    display_name = "Key Vault Network Access Restrictions"
    description = "Ensured Key Vaults have network access restrictions configured"
    enforce = true
}

############ Storage Account Security ############
resource "azurerm_resource_group_policy_assignment" "storage_https_only" {
    name = "storage-https-only"
    resource_group_id = var.resource_group_id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9"
    display_name = "Storage Account HTTPS Only"
    description = "Ensures storage accounts only accept HTTPS traffic for Zero Trust network security"
    enforce = true
}

resource "azurerm_resource_group_policy_assignment" "Storage_public_access" {
    name = "storage-public-access-denied"
    resource_group_id = var.resource_group_id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/4fa4b6c0-31ca-4c0d-b10d-24b96f62a751"
    display_name = "Storage Account Public Access Restriction"
    description = "Prevents storage accounts from allowing unrestricted public access"
    enforce = true
}

############### VM Secuirty Policies ##################
resource "azurerm_resource_group_policy_assignment" "vm_disk_encryption" {
    name = "vm-disk-encryption-required"
    resource_group_id = var.resource_group_id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0961003e-5a0a-4549-abde-af6a37f2724d"
    display_name = "VM Disk Encryption Required"
    description = "Ensures virtual machines have disk encryption enabled for data protection"
    enforce = true
}

resource "azurerm_resource_group_policy_assignment" "vm_managed_disks" {
    name = "vm-managed-disks-required"
    resource_group_id = var.resource_group_id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
    display_name = "VM Managed Disks Required"
    description = "Ensures virtual machines use managed disks for better secuirty and management"
    enforce = true
}

############## Network Security Policies #################
resource "azurerm_resource_group_policy_assignment" "nsg_ssh_restriction" {
    name = "nsg-ssh-restriction"
    resource_group_id = var.resource_group_id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/2c89a2e5-7285-40fe-afe0-ae8654b92fab"
    display_name = "SSH Access Restriction"
    description = "Prevent NSGs from allowing unrestricted SSH access from the internet"
    enforce = true
}

resource "azurerm_resource_group_policy_assignment" "nsg_rdp_restriction" {
    name = "nsg-rdp-restriction"
    resource_group_id = var.resource_group_id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e372f825-a257-4fb8-9175-797a8a8627d6"
    display_name = "RDP Access Restriction"
    description = "Prevents NSGs from allowing unrestricted RDP access from the internet"
    enforce = true
}
resource "azurerm_resource_group_policy_assignment" "subnet_nsg_required" {
    name = "subnet-nsg-required"
    resource_group_id = var.resource_group_id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e71308d3-144b-4262-b144-efdc3cc90517"
    display_name = "Subnet NSG Association Required"
    description = "Ensures all subnets are associated with Network Secuirty Groups"
    enforce = true
}

############# Resource Tagging Policy ##############
resource "azurerm_policy_definition" "zero_trust_tagging" {
    name = "zero-trust-required-tags"
    policy_type = "Custom"
    mode = "Indexed"
    display_name = "Zero Trust Required Resource Tags"
    description = "Ensures all resources have required Zero Trust compliance tags"

    policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field = "type"
          notIn = [
            "Microsoft.Resources/subscriptions",
            "Microsoft.Resources/resourceGroups"
          ]
        },
        {
          anyOf = [
            {
              field = "tags['Environment']"
              exists = "false"
            },
            {
              field = "tags['Project']"
              exists = "false"
            },
            {
              field = "tags['Owner']"
              exists = "false"
            }
          ]
        }
      ]
    }
    then = {
      effect = "audit"
    }
  })

    parameters = jsonencode({})
}

resource "azurerm_resource_group_policy_assignment" "zero_trust_tagging" {
    name = "zero-trust-tagging-policy"
    resource_group_id = var.resource_group_id
    policy_definition_id = azurerm_policy_definition.zero_trust_tagging.id
    display_name = "Zero Trust Resource Tagging"
    description = "Ensures all resources follow Zero Trust tagging standards for governance"
    enforce = false # Audit-only for testing purposes
}

########## Security Monitoring Policy ##############
resource "azurerm_resource_group_policy_assignment" "audit_vm_agent" {
    name = "audit-vm-monitoring-agent"
    resource_group_id = var.resource_group_id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a4fe33eb-e377-4efb-ab31-0784311bc499"
    display_name = "Audit VM Monitoring Agent"
    description = "Audits virtual machines that don't have monitoring agents installed"
    enforce = false # Audit only for testing
}