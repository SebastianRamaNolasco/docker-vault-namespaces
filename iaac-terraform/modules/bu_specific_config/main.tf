
terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
    }
  }
}

resource "vault_policy" "bu_kv_reader_policy" {
  name     = "kv-reader"

  policy = <<-EOT
    # Grant read-only access to all secrets under the 'secrets' KV engine
    # mounted in this namespace.
    path "secrets/data/*" {
      capabilities = ["read", "list"]
    }
    path "secrets/metadata/*" { # Needed for UI and some CLI list operations with KV v2
      capabilities = ["list"]
    }

    # ADD THIS SECTION:
    # Allow access to the internal UI path for the 'secrets' mount.
    # This is required by recent Vault CLI versions for kv operations.
    # The path is relative to the namespace where the policy is applied.
    path "sys/internal/ui/mounts/secrets" {
      capabilities = ["read"]
    }
    # It might also need access to sub-paths for specific secrets, so be generous or specific:
    path "sys/internal/ui/mounts/secrets/*" { # More permissive for any secret under the mount
      capabilities = ["read"]
    }
  EOT
}