variable "name" {}

variable "bucket_name" {}

variable "force_destroy_bucket" {
  default = false
}

variable "include_global_service_events" {
  default = true
}

variable "account_id" {}