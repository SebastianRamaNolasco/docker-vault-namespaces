terraform { /* ... required_providers ... */ }


resource "vault_policy" "bu_kv_reader_policy" {
  name     = "kv-reader"
  # This policy is created in the child namespace (e.g., admin/bu-0001)

  policy = <<-EOT
    # Templated access based on the 'team' metadata of the canonical central group.
    # The entity is part of a group whose ID is var.central_reader_group_id.
    # We need to access metadata of that specific group.
    # entity.groups.ids.<group_id>.metadata.<key>
    path "secrets/data/{{identity.groups.ids['${var.central_reader_group_id}'].metadata.team}}/*" {
      capabilities = ["read"]
    }
    path "secrets/metadata/{{identity.groups.ids['${var.central_reader_group_id}'].metadata.team}}/*" {
      capabilities = ["list", "read"]
    }

    # Grant access to the specific example secret (application1 for bu-0001).
    ${ var.specific_application_secret_name != null ? <<-SPECIFIC_SECRET
    path "secrets/data/${var.specific_application_secret_name}" {
      capabilities = ["read"]
    }
    path "secrets/metadata/${var.specific_application_secret_name}" {
      capabilities = ["list", "read"]
    }
    SPECIFIC_SECRET
    : "" }
  EOT
}

# Assign this policy (which exists in the child NS) to the CANONICAL group from the parent NS.
resource "vault_identity_group_policies" "assign_kv_reader_to_central_group_in_child_ns" {
  # Provider context is the child namespace (e.g., admin/bu-0001)
  group_id = var.central_reader_group_id # ID of the group from 'admin' namespace
  policies = [vault_policy.bu_kv_reader_policy.name] # Policy from this child namespace
  exclusive = false
  namespace = "admin"
}