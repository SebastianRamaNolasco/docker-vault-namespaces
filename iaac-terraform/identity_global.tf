
# Central Identity Groups in 'admin' namespace
resource "vault_identity_group" "central_reader_groups" {
  for_each = var.bu_details
  provider = vault.ns_admin # Created in 'admin' namespace
  name     = "${each.value.app_name}-reader"
  type     = "internal"
  metadata = {
    bu    = each.value.app_name
    owner = each.value.owner
    team  = each.value.team
  }
  depends_on = [vault_namespace.admin]
}

# Enable userpass auth method in 'admin' namespace
resource "vault_auth_backend" "userpass_admin" {
  provider    = vault.ns_admin
  path        = "userpass" # Enables at admin/userpass
  type        = "userpass"
  description = "Userpass auth for admin namespace users"
  depends_on  = [vault_namespace.admin]
}

# Create users in 'admin/userpass' and assign them to central groups
resource "vault_generic_endpoint" "userpass_users" {
  for_each = var.user_details
  provider = vault.ns_admin # Users created in 'admin' namespace
  path     = "auth/userpass/users/${each.key}"
  data_json = jsonencode({
    password = each.value.password
    groups   = [vault_identity_group.central_reader_groups[each.value.group_key].name]
  })
  depends_on = [
    vault_auth_backend.userpass_admin,
    vault_identity_group.central_reader_groups
  ]
}

# --- Data sources for BU namespace's "token" auth method accessors ---
/* data "vault_auth_backend" "token_auth_ns_admin_bu0001" {
  provider   = vault.ns_admin_bu0001
  path       = "token"
  depends_on = [vault_namespace.bu["0001"]]
}
data "vault_auth_backend" "token_auth_ns_admin_bu0002" {
  provider   = vault.ns_admin_bu0002
  path       = "token"
  depends_on = [vault_namespace.bu["0002"]]
}
data "vault_auth_backend" "token_auth_ns_admin_bu0003" {
  provider   = vault.ns_admin_bu0003
  path       = "token"
  depends_on = [vault_namespace.bu["0003"]]
}
 */
/* locals {
  bu_identity_related_accessors = {
    "0001" = data.vault_auth_backend.token_auth_ns_admin_bu0001.accessor
    "0002" = data.vault_auth_backend.token_auth_ns_admin_bu0002.accessor
    "0003" = data.vault_auth_backend.token_auth_ns_admin_bu0003.accessor
  }
} */