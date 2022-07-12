variable "environment" {
  type = string
  description = "Deployment environment (development, staging, test or production)"
}

variable "tf_runner_account_id" {
  type = string
  description = "User ID"
}

variable "clusters" {
  type = map
  description = "Clusters settings"
}
