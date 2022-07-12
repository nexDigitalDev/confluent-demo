resource "confluent_environment" "environment" {
  display_name = "${var.environment}"
}

resource "confluent_kafka_cluster" "clusters_basic" {
  for_each = var.clusters.basic
  display_name = each.key
  availability = each.value.zone_setting
  cloud = each.value.provider
  region = each.value.region
  basic {}
  environment {
    id = confluent_environment.environment.id
  }
}

resource "confluent_kafka_cluster" "clusters_standard" {
  for_each = var.clusters.standard
  display_name = each.key
  availability = each.value.zone_setting
  cloud = each.value.provider
  region = each.value.region
  standard {}
  environment {
    id = confluent_environment.environment.id
  }
}

locals {
  clusters = merge(confluent_kafka_cluster.clusters_basic, confluent_kafka_cluster.clusters_standard)
}

resource "confluent_service_account" "clusters_admin" {
  display_name = "clusters_admin_${var.environment}"
  description  = "Service account to manage Kafka clusters in ${var.environment} environment"
}

resource "confluent_role_binding" "kafka_clusters_admin_rb" {
  for_each = local.clusters
  principal   = "User:${confluent_service_account.clusters_admin.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = each.value.rbac_crn
}

resource "confluent_api_key" "clusters_admin_kafka_api_key" {
  for_each = local.clusters
  display_name = "clusters_admin_kafka_api_key_${each.key}"
  description  = "Kafka API Key that is owned by 'clusters_admin_${var.environment}' service account for the cluster ${each.key}"
  owner {
    id          = confluent_service_account.clusters_admin.id
    api_version = confluent_service_account.clusters_admin.api_version
    kind        = confluent_service_account.clusters_admin.kind
  }

  managed_resource {
    id          = each.value.id
    api_version = each.value.api_version
    kind        = each.value.kind

    environment {
      id = confluent_environment.environment.id
    }
  }

  depends_on = [
    confluent_role_binding.kafka_clusters_admin_rb
  ]
}

resource "vault_generic_secret" "clusters_admin_api_key" {
  for_each = local.clusters
  path = "secret/ccloud/cluster/${each.key}/api_key/${confluent_service_account.clusters_admin.id}"
  data_json = <<EOT
{
  "key":   "${confluent_api_key.clusters_admin_kafka_api_key[each.key]["id"]}",
  "secret": "${confluent_api_key.clusters_admin_kafka_api_key[each.key]["secret"]}"
}
EOT
}

resource "confluent_service_account" "producer_service_account" {
  display_name = "producer_${var.environment}"
  description  = "Service account for producer apps in ${var.environment}"
}

resource "confluent_api_key" "producer_kafka_api_key" {
  for_each = local.clusters
  display_name = "producer_kafka_api_key_${each.key}"
  description  = "Kafka API Key that is owned by 'producer_${var.environment}' service account for the cluster ${each.key}"
  owner {
    id          = confluent_service_account.producer_service_account.id
    api_version = confluent_service_account.producer_service_account.api_version
    kind        = confluent_service_account.producer_service_account.kind
  }

  managed_resource {
    id          = each.value.id
    api_version = each.value.api_version
    kind        = each.value.kind

    environment {
      id = confluent_environment.environment.id
    }
  }
}

resource "vault_generic_secret" "producer_kafka_api_key" {
  for_each = local.clusters
  path = "secret/ccloud/cluster/${each.key}/api_key/${confluent_service_account.producer_service_account.id}"
  data_json = <<EOT
{
  "key":   "${confluent_api_key.producer_kafka_api_key[each.key]["id"]}",
  "secret": "${confluent_api_key.producer_kafka_api_key[each.key]["secret"]}"
}
EOT
}

resource "confluent_service_account" "consumer_service_account" {
  display_name = "consumer_${var.environment}"
  description  = "Service account for consumer apps in ${var.environment}"
}

resource "confluent_api_key" "consumer_kafka_api_key" {
  for_each = local.clusters
  display_name = "consumer_kafka_api_key_${each.key}"
  description  = "Kafka API Key that is owned by 'consumer_${var.environment}' service account for the cluster ${each.key}"
  owner {
    id          = confluent_service_account.consumer_service_account.id
    api_version = confluent_service_account.consumer_service_account.api_version
    kind        = confluent_service_account.consumer_service_account.kind
  }

  managed_resource {
    id          = each.value.id
    api_version = each.value.api_version
    kind        = each.value.kind

    environment {
      id = confluent_environment.environment.id
    }
  }
}

resource "vault_generic_secret" "consumer_kafka_api_key" {
  for_each = local.clusters
  path = "secret/ccloud/cluster/${each.key}/api_key/${confluent_service_account.consumer_service_account.id}"
  data_json = <<EOT
{
  "key":   "${confluent_api_key.consumer_kafka_api_key[each.key]["id"]}",
  "secret": "${confluent_api_key.consumer_kafka_api_key[each.key]["secret"]}"
}
EOT
}

