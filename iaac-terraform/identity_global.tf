
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


resource "vault_identity_group_policies" "assign_bu0001_policy_to_app1_reader" {
  provider = vault.ns_admin # Operate in the 'admin' namespace

  group_id = vault_identity_group.central_reader_groups["0001"].id
  policies = [
    # Policy name is "bu-0001/kv-reader" relative to the 'admin' namespace
    "${module.bu_config_instance_0001.bu_namespace_name}/${module.bu_config_instance_0001.policy_name}"
  ]
  exclusive = false
  depends_on = [module.bu_config_instance_0001]
}

resource "vault_identity_group_policies" "assign_bu0002_policy_to_app2_reader" {
  provider = vault.ns_admin

  group_id = vault_identity_group.central_reader_groups["0002"].id
  policies = [
    "${module.bu_config_instance_0002.bu_namespace_name}/${module.bu_config_instance_0002.policy_name}"
  ]
  exclusive = false
  depends_on = [module.bu_config_instance_0002]
}

resource "vault_identity_group_policies" "assign_bu0003_policy_to_app3_reader" {
  provider = vault.ns_admin

  group_id = vault_identity_group.central_reader_groups["0003"].id
  policies = [
    "${module.bu_config_instance_0003.bu_namespace_name}/${module.bu_config_instance_0003.policy_name}"
  ]
  exclusive = false
  depends_on = [module.bu_config_instance_0003]
}
