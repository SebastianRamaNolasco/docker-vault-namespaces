variable "vault_addr" {
  description = "Vault server address"
  type        = string
  default     = "http://127.0.0.1:8200"
}

variable "vault_token" {
  description = "Vault root token for provisioning"
  type        = string
  sensitive   = true
  default = "root"
}

variable "bu_details" {
  description = "Map of Business Unit details"
  type = map(object({
    name     = string
    app_name = string
    owner    = string
    team     = string
  }))
  default = {
    "0001" = { name = "bu-0001", app_name = "app1", owner = "alice", team = "team1" }
    "0002" = { name = "bu-0002", app_name = "app2", owner = "bob", team = "team2" }
    "0003" = { name = "bu-0003", app_name = "app3", owner = "jane", team = "team3" }
  }
}

variable "user_details" {
  description = "Map of user details"
  type = map(object({
    password  = string
    group_key = string # Key to link to bu_details for group association
  }))
  default = {
    "alice" = { password = "AlicePassword123!", group_key = "0001" }
    "bob"   = { password = "BobPassword123!", group_key = "0002" }
    "jane"  = { password = "JanePassword123!", group_key = "0003" }
  }
}