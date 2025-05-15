# variables.tf

variable "vault_addr" {
  description = "Vault server address"
  type        = string
  default     = "http://127.0.0.1:8200"
}

variable "vault_token" {
  description = "Vault root token for provisioning"
  type        = string
  sensitive   = true
  default     = "root"
}

variable "bu_details" {
  description = "Map of Business Unit details, including their primary team and owner." # <<< ADDED A DESCRIPTION STRING
  type = map(object({
    name  = string # e.g., "bu-0001" (namespace segment)
    owner = string
    team  = string # e.g., "team1", "team2", "team3"
  }))
  default = {
    "0001" = { name = "bu-0001", owner = "alice", team = "team1" }
    "0002" = { name = "bu-0002", owner = "bob", team = "team2" }
    "0003" = { name = "bu-0003", owner = "jane", team = "team3" }
  }
}

variable "user_details" {
  description = "Map of user details and their primary team affiliation"
  type = map(object({
    password = string
    team_key = string # Key to link to bu_details for team group association (e.g., "0001" for team1)
  }))
  default = {
    "alice" = { password = "AlicePassword123!", team_key = "0001" }
    "bob"   = { password = "BobPassword123!", team_key = "0002" }
    "jane"  = { password = "JanePassword123!", team_key = "0003" }
  }
}

variable "shared_details" {
  description = "Details for the shared namespace"
  type = object({
    owner = string
  })
  default = {
    owner = "robert"
  }
}