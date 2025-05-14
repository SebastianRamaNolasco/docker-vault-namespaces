
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

output "bu_kv_reader_policy_ids" {
  description = "IDs of the KV reader policies created for each BU."
  value = {
    "0001" = module.bu_config_instance_0001.policy_id
    "0002" = module.bu_config_instance_0002.policy_id
    "0003" = module.bu_config_instance_0003.policy_id
  }
}
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> origin/main
output "debug_bu0001_ns_name" {
  value = module.bu_config_instance_0001.bu_namespace_name
}
output "debug_bu0001_policy_name" {
  value = module.bu_config_instance_0001.policy_name
<<<<<<< HEAD
}
>>>>>>> 5c90157 (fixing mappings and acls)
=======
}
>>>>>>> origin/main
