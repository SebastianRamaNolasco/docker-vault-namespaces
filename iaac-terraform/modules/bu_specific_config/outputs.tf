output "bu_team_reader_group_id" {
  description = "ID of the BU-specific team reader group."
  value       = vault_identity_group.bu_team_reader_group.id
}

output "bu_namespace_name" { // This was used to construct policy FQNs
  description = "The name of the BU namespace (e.g., bu-0001)."
  value       = var.bu_config.name
}

output "policy_name" { // This was used to construct policy FQNs
  description = "The simple name of the team-specific KV reader policy created."
  value       = vault_policy.team_kv_reader_policy.name
}