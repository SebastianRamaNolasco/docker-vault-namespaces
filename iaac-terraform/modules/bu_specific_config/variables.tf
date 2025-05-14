
variable "bu_key" {
  description = "The key of the BU (e.g., '0001')"
  type        = string
}

variable "bu_config" { // <<< KEEP THIS ONE (or the other, just ensure only one remains)
  description = "Configuration object for the BU"
  type = object({
    name     = string # This is "bu-0001", "bu-0002", etc.
    app_name = string
    owner    = string
    team     = string
  })
}

variable "central_reader_group_id" {
  description = "ID of the central reader group whose metadata is used in policy templating."
  type        = string
}

variable "specific_application_secret_name" {
  description = "Name of a specific application secret to grant access to (e.g., 'application1')"
  type        = string
  default     = null
}
