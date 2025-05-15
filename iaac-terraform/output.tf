output "admin_namespace_id" {
  value = vault_namespace.admin.id
}

output "bu_namespace_ids" {
  value = { for k, v in vault_namespace.bu : k => v.id }
}

output "shared_namespace_id" {
  value = vault_namespace.shared.id
}

output "userpass_admin_accessor" {
  value = vault_auth_backend.userpass_admin.accessor
}

output "user_entity_ids" {
  value = { for k, v in vault_identity_entity.user_entities : k => v.id }
}

output "team_meta_group_ids" {
  value = { for k, v in vault_identity_group.team_meta_groups : k => v.id }
}

output "bu_specific_team_group_ids" {
  description = "IDs of the BU-specific team reader groups."
  value = {
    "0001" = module.bu_config_instance_0001.bu_team_reader_group_id
    "0002" = module.bu_config_instance_0002.bu_team_reader_group_id
    "0003" = module.bu_config_instance_0003.bu_team_reader_group_id
  }
}

output "bu_kv_reader_policy_names_from_module" {
  description = "Simple names of the KV reader policies created by each BU module."
  value = {
    "0001" = module.bu_config_instance_0001.policy_name
    "0002" = module.bu_config_instance_0002.policy_name
    "0003" = module.bu_config_instance_0003.policy_name
  }
}