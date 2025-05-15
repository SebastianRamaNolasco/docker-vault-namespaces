# Secret for bu-0001
resource "vault_generic_secret" "app1_secret" {
  provider   = vault.ns_admin_bu0001
  path       = "secrets/application1"
  depends_on = [vault_mount.bu_kv["0001"]]

  data_json = jsonencode({
    username = "wibble"
    password = "strongpassword"
  })
}

# Secret for shared
resource "vault_generic_secret" "jenkins_secret" {
  provider   = vault.ns_admin_shared
  path       = "secrets/jenkins"
  depends_on = [vault_mount.shared_kv]

  data_json = jsonencode({
    username = "wibble"
    password = "strongpassword"
  })
}