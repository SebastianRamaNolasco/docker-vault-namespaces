
output "policy_name" {
  description = "The name of the KV reader policy created in this BU."
  value       = vault_policy.bu_kv_reader_policy.name
}

output "policy_id" {
  description = "The ID of the KV reader policy created in this BU."
  value       = vault_policy.bu_kv_reader_policy.id
}

# DELETED/COMMENTED OUT:
# output "group_alias_id" {
#   description = "The ID of the BU reader group alias."
#   value       = vault_identity_group_alias.bu_reader_group_alias.id
# }
#
# output "group_alias_name" {
#   description = "The name of the BU reader group alias."
#   value       = vault_identity_group_alias.bu_reader_group_alias.name
# }