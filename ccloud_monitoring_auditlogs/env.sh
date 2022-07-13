export CONNECTOR_OWNER=splunk
export CONNECTOR_NAME=kafka-connect-splunk
export CONNECTOR_VERSION=2.0.2

export BASIC_AUTH_CREDENTIALS_SOURCE="USER_INFO"
export SCHEMA_REGISTRY_BASIC_AUTH_USER_INFO="Sr_API_Key:Sr_API_Secret"
export SCHEMA_REGISTRY_URL="Sr_endpoint"

# for standalone mode BOOTSTRAP_SERVERS is  audit logs cluster
# To access your Credentials on Confluent Cloud, see below examples
export BOOTSTRAP_SERVERS="auditlogs_endpoint"
export SASL_JAAS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username='Cloud_API_Key' password='Cloud_API_Secret';"



