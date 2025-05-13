
terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.20.0"
    }
  }
}

/* variable "vault_addr" {
  description = "Vault server address"
  type        = string
  default     = "http://127.0.0.1:8200"
}

variable "vault_token" {
  description = "Vault root token for provisioning"
  type        = string
  sensitive   = true
  default     = "root"
} */

provider "vault" {
  address = var.vault_addr
  token   = var.vault_token
}

provider "vault" {
  alias     = "ns_admin"
  address   = var.vault_addr
  token     = var.vault_token
  namespace = "admin"
}

provider "vault" {
  alias     = "ns_admin_bu0001"
  address   = var.vault_addr
  token     = var.vault_token
  namespace = "admin/bu-0001"
}

provider "vault" {
  alias     = "ns_admin_bu0002"
  address   = var.vault_addr
  token     = var.vault_token
  namespace = "admin/bu-0002"
}

provider "vault" {
  alias     = "ns_admin_bu0003"
  address   = var.vault_addr
  token     = var.vault_token
  namespace = "admin/bu-0003"
}

provider "vault" {
  alias     = "ns_admin_shared"
  address   = var.vault_addr
  token     = var.vault_token
  namespace = "admin/shared"
}