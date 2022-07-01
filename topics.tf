locals {
  topics_list = flatten([
    for cluster in keys(var.clusters.basic) : [
      for topic in keys(var.clusters.basic[cluster]["topics"]) : {
        cluster = confluent_kafka_cluster.clusters[cluster]
        topic = {
          topic_name = topic
          topic_settings = var.clusters.basic[cluster]["topics"][topic]
        }
      }
    ]
  ])
}

locals {
  topics_map = {
    for obj in local.topics_list : "${obj.cluster.display_name}_${obj.topic.topic_name}" => obj
  }
}

resource "confluent_kafka_topic" "topics" {
  for_each = local.topics_map
  kafka_cluster {
    id = each.value.cluster.id
  }
  topic_name         = each.value.topic.topic_name
  partitions_count   = each.value.topic.topic_settings.partitions_count
  rest_endpoint      = each.value.cluster.rest_endpoint
  config = {
    "cleanup.policy"    = each.value.topic.topic_settings.cleanup_policy
  }
  credentials {
    key    = confluent_api_key.clusters_admin_kafka_api_key[each.value.cluster.display_name].id
    secret = confluent_api_key.clusters_admin_kafka_api_key[each.value.cluster.display_name].secret
  }
}

resource "confluent_kafka_acl" "producer_write_on_topic" {
  for_each = local.topics_map
  kafka_cluster {
    id = each.value.cluster.id
  }
  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.topics[each.key].topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.producer_service_account.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint =  each.value.cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.clusters_admin_kafka_api_key[each.value.cluster.display_name].id
    secret = confluent_api_key.clusters_admin_kafka_api_key[each.value.cluster.display_name].secret
  }
}

resource "confluent_kafka_acl" "consumer_read_on_topic_aws" {
  for_each = local.topics_map
  kafka_cluster {
    id = each.value.cluster.id
  }
  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.topics[each.key].topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.consumer_service_account.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = each.value.cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.clusters_admin_kafka_api_key[each.value.cluster.display_name].id
    secret = confluent_api_key.clusters_admin_kafka_api_key[each.value.cluster.display_name].secret
  }
}

