variable "bu_key" { /* ... */ }
variable "bu_config" { /* ... */ }
variable "central_reader_group_id" {
  description = "ID of the central reader group this BU's policy should be tied to."
  type        = string
}
variable "specific_application_secret_name" { /* ... */ }