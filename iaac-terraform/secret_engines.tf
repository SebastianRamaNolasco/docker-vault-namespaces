resource "vault_mount" "bu_kv" {
  for_each = var.bu_details
  provider = vault.ns_admin # The mount itself is configured from the parent namespace

  namespace = vault_namespace.bu[each.key].path_fq # Target namespace path e.g., admin/bu-0001
  path      = "secrets"                            # Mount path within the target namespace
  type      = "kv"
  options = {
    version = "2"
  }
  description = "KV Secrets for ${each.value.name}"
  depends_on = [
    vault_namespace.bu
  ]
}

resource "vault_mount" "shared_kv" {
  provider  = vault.ns_admin                 # Configured from 'admin' namespace
  namespace = vault_namespace.shared.path_fq # Target namespace admin/shared
  path      = "secrets"                      # Mount path within admin/shared
  type      = "kv"
  options = {
    version = "2"
  }
  description = "Shared KV Secrets"
  depends_on = [
    vault_namespace.shared
  ]
}