variable "bu_key" {
  description = "The key of the BU (e.g., '0001')"
  type        = string
}

variable "bu_config" {
  description = "Configuration object for the BU"
  type = object({
    name  = string
    owner = string
    team  = string
  })
}

variable "specific_application_secret_name" {
  description = "Name of a specific application secret to grant access to (e.g., 'application1')"
  type        = string
  default     = null
}

variable "parent_namespace_path" {
  description = "Path of the parent namespace, e.g., 'admin'."
  type        = string
}