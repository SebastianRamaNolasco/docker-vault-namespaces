
output "admin_namespace_id" {
  value = vault_namespace.admin.id
}

output "bu_namespace_ids" {
  value = { for k, v in vault_namespace.bu : k => v.id }
}

output "shared_namespace_id" {
  value = vault_namespace.shared.id
}

output "central_group_ids" {
  value = { for k, v in vault_identity_group.central_reader_groups : k => v.id }
}

output "userpass_admin_accessor" {
  value = vault_auth_backend.userpass_admin.accessor
}

# --- CORRECTED OUTPUTS ---
output "bu_kv_reader_policy_names" {
  description = "Names of the KV reader policies created for each BU."
  value = {
    "0001" = module.bu_config_instance_0001.policy_name
    "0002" = module.bu_config_instance_0002.policy_name
    "0003" = module.bu_config_instance_0003.policy_name
    # You can also construct this with a loop if you prefer, but explicit is fine for 3
    # Example with a loop (less direct if module names vary too much from keys):
    # for k, bu_detail in var.bu_details : k => module.bu_config_instance_${k}.policy_name
    # However, module names are bu_config_instance_0001 etc. not bu_config_instance_bu-0001
  }
}

/* output "bu_group_alias_ids" {
  description = "IDs of the group aliases created for each BU."
  value = {
    "0001" = module.bu_config_instance_0001.group_alias_id
    "0002" = module.bu_config_instance_0002.group_alias_id
    "0003" = module.bu_config_instance_0003.group_alias_id
  }
} */

# You might want other outputs from the module as well, e.g., policy IDs
output "bu_kv_reader_policy_ids" {
  description = "IDs of the KV reader policies created for each BU."
  value = {
    "0001" = module.bu_config_instance_0001.policy_id
    "0002" = module.bu_config_instance_0002.policy_id
    "0003" = module.bu_config_instance_0003.policy_id
  }
}