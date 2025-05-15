resource "vault_namespace" "admin" {
  path = "admin"
}

resource "vault_namespace" "bu" {
  for_each = var.bu_details
  provider = vault.ns_admin
  path     = each.value.name # e.g., "bu-0001"
  custom_metadata = {
    bu    = each.value.name
    owner = each.value.owner
    team  = each.value.team
  }
  depends_on = [vault_namespace.admin]
}

resource "vault_namespace" "shared" {
  provider        = vault.ns_admin
  path            = "shared"
  custom_metadata = {
    bu    = "shared"
    owner = var.shared_details.owner
  }
  depends_on = [vault_namespace.admin]
}