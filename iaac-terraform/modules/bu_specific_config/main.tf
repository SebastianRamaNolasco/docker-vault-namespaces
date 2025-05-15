terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      # version = ">= 4.0.0" # Optional
    }
  }
}

# --- BU-Specific Policy for the Team ---
resource "vault_policy" "team_kv_reader_policy" {
  name = "${var.bu_config.team}-kv-reader" # e.g., team1-kv-reader

  policy = <<-EOT
    path "secrets/data/${var.bu_config.team}/*" {
      capabilities = ["read", "list"]
    }
    path "secrets/metadata/${var.bu_config.team}/*" {
      capabilities = ["list"]
    }
    ${ var.specific_application_secret_name != null ? <<-SPECIFIC_SECRET
    path "secrets/data/${var.specific_application_secret_name}" {
      capabilities = ["read", "list"]
    }
    path "secrets/metadata/${var.specific_application_secret_name}" {
      capabilities = ["list"]
    }
    SPECIFIC_SECRET
    : "" }
    path "sys/internal/ui/mounts/secrets" {
      capabilities = ["read"]
    }
    path "sys/internal/ui/mounts/secrets/*" {
      capabilities = ["read"]
    }
  EOT
}

# --- BU-Specific "Team Implementation Group" ---
resource "vault_identity_group" "bu_team_reader_group" {
  name = "${var.bu_config.team}-reader" # e.g., team1-reader (within admin/bu-0001)
  type = "internal"
  metadata = { # CORRECTED from custom_metadata
    bu    = var.bu_config.name
    owner = var.bu_config.owner
    team  = var.bu_config.team
  }
  policies = [vault_policy.team_kv_reader_policy.name]
}