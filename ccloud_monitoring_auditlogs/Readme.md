# Confluent Cloud AuditLogs integration with Splunk Dashboards
This repo shows how to monitor audit logs using Splunk, a leader in security information and event management. 
Splunk dashboards.
In this solution, we will start by configuring a self-managed connector that will consume data from the Confluent Cloud Auditlogs cluster and send it to Splunk.
The Splunk enterprise instance and the Kafka connector are run on docker.
![image](https://user-images.githubusercontent.com/103249046/178685148-052a8ca1-dae5-4ae7-a1c9-a2049a49e7ac.png)

## Requierement :
- A Confluent account cloud and organization
- Confluent cli
- Confluent cloud standard or dedicated cluster
- Docker
## Quick start :

1- Create Cloud APIKey :

```bash
$confluent api-key create --resource cloud
```
2-Create Schema registry APIKey:

```bash
$ confluent api-key create --resource sr_id
```
3-Edit env.sh

```bash
$ export CONNECTOR_OWNER=splunk
$ export CONNECTOR_NAME=kafka-connect-splunk
$ export CONNECTOR_VERSION=2.0.2
$ export BASIC_AUTH_CREDENTIALS_SOURCE="USER_INFO"
$ export SCHEMA_REGISTRY_BASIC_AUTH_USER_INFO="SR API Key:SR API Secret" 
$ export SCHEMA_REGISTRY_URL="SR Confluent Cloud endpoint"
$ export BOOTSTRAP_SERVERS="Auditlogs_endpoint"
$ export SASL_JAAS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username='Cloud API Key' password='CLoud API Secret';" 
```

4- Run : 
First ,
```bash
$ source env.sh
```
Then the docker build ,
```bash
$ docker build \
    --build-arg CONNECTOR_OWNER=${CONNECTOR_OWNER} \
    --build-arg CONNECTOR_NAME=${CONNECTOR_NAME} \
    --build-arg CONNECTOR_VERSION=${CONNECTOR_VERSION} \
    -t localbuild/connect_standalone_with_${CONNECTOR_NAME}:${CONNECTOR_VERSION} \
    -f ./Docker-connect/standalone/Dockerfile ./Docker-connect/standalone
```
Finally , run the docker compose

```bash
$ docker-compose up -d 
```
5-Visualization
- Open Splunk endpoint : http://localhost:8000/
- Login : 
username : admin password : password
