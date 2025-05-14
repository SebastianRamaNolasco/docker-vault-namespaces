
module "bu_config_instance_0001" {
  source = "./modules/bu_specific_config"
  providers = { vault = vault.ns_admin_bu0001 }

  bu_key                            = "0001"
  bu_config                         = var.bu_details["0001"]
  central_reader_group_id           = vault_identity_group.central_reader_groups["0001"].id
  #identity_engine_mount_accessor    = local.bu_identity_related_accessors["0001"] # Pass the accessor
  specific_application_secret_name  = "application1"

  depends_on = [ /* ... */ ]
}

# Instance for BU-0002
module "bu_config_instance_0002" {
  source = "./modules/bu_specific_config"
  providers = { vault = vault.ns_admin_bu0002 }

  bu_key                            = "0002"
  bu_config                         = var.bu_details["0002"]
  central_reader_group_id           = vault_identity_group.central_reader_groups["0002"].id
  #identity_engine_mount_accessor    = local.bu_identity_related_accessors["0002"] # Pass the accessor
  specific_application_secret_name  = null

  depends_on = [ /* ... */ ]
}

# Instance for BU-0003
module "bu_config_instance_0003" {
  source = "./modules/bu_specific_config"
  providers = { vault = vault.ns_admin_bu0003 }

  bu_key                            = "0003"
  bu_config                         = var.bu_details["0003"]
  central_reader_group_id           = vault_identity_group.central_reader_groups["0003"].id
  #identity_engine_mount_accessor    = local.bu_identity_related_accessors["0003"] # Pass the accessor
  specific_application_secret_name  = null

  depends_on = [ /* ... */ ]
}