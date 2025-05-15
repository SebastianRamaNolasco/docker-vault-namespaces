# Instance for BU-0001 ("0001" is the key from var.bu_details)
module "bu_config_instance_0001" {
  source = "./modules/bu_specific_config"

  providers = {
    vault = vault.ns_admin_bu0001
  }

  bu_key    = "0001"
  bu_config = var.bu_details["0001"]

  specific_application_secret_name = "application1"
  parent_namespace_path            = vault_namespace.admin.path

  depends_on = [vault_namespace.bu["0001"]]
}

# Instance for BU-0002
module "bu_config_instance_0002" {
  source = "./modules/bu_specific_config"

  providers = {
    vault = vault.ns_admin_bu0002
  }

  bu_key    = "0002"
  bu_config = var.bu_details["0002"]

  specific_application_secret_name = null
  parent_namespace_path            = vault_namespace.admin.path

  depends_on = [vault_namespace.bu["0002"]]
}

# Instance for BU-0003
module "bu_config_instance_0003" {
  source = "./modules/bu_specific_config"

  providers = {
    vault = vault.ns_admin_bu0003
  }

  bu_key    = "0003"
  bu_config = var.bu_details["0003"]

  specific_application_secret_name = null
  parent_namespace_path            = vault_namespace.admin.path

  depends_on = [vault_namespace.bu["0003"]]
}