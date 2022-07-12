terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.0.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = data.vault_generic_secret.confluent_cloud_api_key.data["key"]
  cloud_api_secret = data.vault_generic_secret.confluent_cloud_api_key.data["secret"]
}

provider "vault" {
  address = "http://127.0.0.1:8200"
}
