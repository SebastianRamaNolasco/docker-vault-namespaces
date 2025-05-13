
resource "vault_namespace" "admin" {
  path = "admin"
}

resource "vault_namespace" "bu" {
  for_each = var.bu_details
  provider = vault.ns_admin # These namespaces are children of 'admin'
  path     = each.value.name
  # CORRECTED ARGUMENT NAME:
  custom_metadata = {
    bu    = each.value.app_name
    owner = each.value.owner
  }
  depends_on = [vault_namespace.admin]
}

resource "vault_namespace" "shared" {
  provider = vault.ns_admin # Child of 'admin'
  path     = "shared"
  # CORRECTED ARGUMENT NAME:
  custom_metadata = {
    bu    = "shared"
    owner = "robert"
  }
  depends_on = [vault_namespace.admin]
}