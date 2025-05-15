# --- User Entities in 'admin' namespace ---
resource "vault_identity_entity" "user_entities" {
  for_each = var.user_details # each.key is "alice", "bob", "jane"
  provider = vault.ns_admin
  name     = each.key
  metadata = {
    description = "Identity entity for user ${each.key}"
    # This entity will be made a member of a 'team_meta_group' below
  }
  # member_group_ids will be handled by vault_identity_group.team_meta_groups
  # OR by adding this entity to the group's member_entity_ids list.
  # Let's add entities to groups when defining the groups.
  depends_on = [vault_namespace.admin]
}

# --- Central "Team Meta-Groups" in 'admin' namespace ---
resource "vault_identity_group" "team_meta_groups" {
  for_each = var.bu_details # each.key is "0001", "0002", "0003"
  provider = vault.ns_admin

  name = "${each.value.team}-reader" # e.g., admin/team1-reader
  type = "internal"
  metadata = {
    bu    = each.value.name
    owner = each.value.owner
    team  = each.value.team
  }
  policies = ["default"] # As per new requirements

  # Make user entities members of these meta-groups
  # We need to find all users belonging to this team.
  member_entity_ids = [
    for user_key, user_detail in var.user_details :
    vault_identity_entity.user_entities[user_key].id if user_detail.team_key == each.key
  ]

  # Make BU-specific groups (from module outputs) members of these meta-groups
  # This assumes module instances are named explicitly in bu_setup.tf
  member_group_ids = [
    each.key == "0001" ? module.bu_config_instance_0001.bu_team_reader_group_id :
    (each.key == "0002" ? module.bu_config_instance_0002.bu_team_reader_group_id :
    module.bu_config_instance_0003.bu_team_reader_group_id)
  ]

  depends_on = [
    vault_namespace.admin,
    vault_identity_entity.user_entities, # Ensure entities exist before adding as members
    # Explicitly depend on module instances for their outputs
    module.bu_config_instance_0001,
    module.bu_config_instance_0002,
    module.bu_config_instance_0003,
  ]
}

# --- Userpass Auth Method and User Login Setup ---
resource "vault_auth_backend" "userpass_admin" {
  provider    = vault.ns_admin
  path        = "userpass"
  type        = "userpass"
  description = "Userpass auth for admin namespace users"
  depends_on  = [vault_namespace.admin]
}

resource "vault_identity_entity_alias" "user_entity_aliases" {
  for_each = var.user_details
  provider = vault.ns_admin
  name           = each.key # Alias name (e.g., "alice" for userpass)
  canonical_id   = vault_identity_entity.user_entities[each.key].id
  mount_accessor = vault_auth_backend.userpass_admin.accessor
  depends_on = [
    vault_identity_entity.user_entities,
    vault_auth_backend.userpass_admin
  ]
}

resource "vault_generic_endpoint" "userpass_users" {
  for_each = var.user_details
  provider = vault.ns_admin
  path     = "auth/userpass/users/${each.key}"
  data_json = jsonencode({
    password = each.value.password
    # 'groups' attribute for userpass_users adds the userpass login to a userpass-level group.
    # For actual Identity Group membership and policy inheritance, entity membership is key.
    # We can still list the team meta group name here for userpass's own records.
    # It doesn't hurt, but the entity's membership in the Identity Group is what Identity system uses.
    groups = [vault_identity_group.team_meta_groups[each.value.team_key].name]
  })
  depends_on = [
    vault_auth_backend.userpass_admin,
    vault_identity_group.team_meta_groups, # Userpass user references this group by name
    vault_identity_entity_alias.user_entity_aliases # Ensure alias exists (good practice)
  ]
}