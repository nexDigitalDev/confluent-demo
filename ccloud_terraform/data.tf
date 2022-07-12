data "vault_generic_secret" "confluent_cloud_api_key" {
  path = "secret/ccloud/api_key/${var.tf_runner_account_id}"
}
