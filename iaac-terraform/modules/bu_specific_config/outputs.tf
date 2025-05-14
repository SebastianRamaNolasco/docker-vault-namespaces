
output "policy_name" {
  description = "The simple name of the KV reader policy created." # e.g., "kv-reader"
  value       = vault_policy.bu_kv_reader_policy.name
}

output "bu_namespace_name" {
  description = "The name of the BU namespace (e.g., bu-0001, which is the last part of admin/bu-0001)."
  value       = var.bu_config.name
}

output "policy_id" {
  description = "The ID/Name of the KV reader policy created in this BU. For vault_policy, ID is the same as its name."
  value       = vault_policy.bu_kv_reader_policy.id # The 'id' attribute of vault_policy is its name
}