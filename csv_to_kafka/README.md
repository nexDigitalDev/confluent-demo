# CSV to Confluent Cloud 


## STEP1: Running a self managed connect worker for confluent cloud :

In order to run a self managed connector for confluent cloud , we start by pooling the docker Kafka connect image :
```bash 
      kafka-connect-ccloud:
    image: confluentinc/cp-kafka-connect-base:6.0.1
    container_name: kafka-connect-ccloud
    ports:
      - 8083:8083
```
Then specify the environement variable , generally : boostrapserver , Schema registry URL , APIKEY/APISECRET Schema registry , APIKEY/APISECRET cluster 

Finally , install the connector plugins and set properly the plugin path in the docker_compose.yml file :

```bash
echo "Installing connector plugins"
        confluent-hub install --no-prompt jcustenborder/kafka-connect-spooldir:2.0.64
```

Let's make sure that our plugins are well installed : 

```bash
   curl -s localhost:8083/connector-plugins|jq '.[].class'
 ```
 <img width="692" alt="Screenshot_1" src="https://user-images.githubusercontent.com/103249046/185931277-455e5830-2574-4e45-9f98-cc871c5ef367.png">
 
# STEP2:
Copy your data folder into the kafka-connect-ccloud container :

```bash
  docker cp folder_path container_id:/folder_name
 ```
To get the container_id  :

```bash
  docker ps 
```

## STEP3:Run the docker compose file 

```bash
  docker-compose up -d
```
## WIP

```bash
curl -i -X PUT -H "Accept:application/json"     -H  "Content-Type:application/json" http://localhost:8083/connectors/source-csv-spooldir-00/config     -d '{
        "connector.class": "com.github.jcustenborder.kafka.connect.spooldir.SpoolDirCsvSourceConnector",
        "input.path": "/data/unprocessed",
        "finished.path": "/data/processed",
        "error.path": "/data/error",
        "input.file.pattern": ".*\\.csv",
        "schema.generation.enabled":"true",
        "csv.first.row.as.header":"true",
        "topic": "orders_spooldir_00",
        "topic.creation.default.partitions"                    : 1,
        "topic.creation.default.replication.factor"            : 3,
        "confluent.license"                                    : "",
        "confluent.topic.bootstrap.servers"                    : "pkc-ymrq7.us-east-2.aws.confluent.cloud:9092",
        "confluent.topic.sasl.jaas.config"                     : "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$KAFKA_API_KEY\" password=\"$KAFKA_API_SECRET\";",
        "confluent.topic.security.protocol"                    : "SASL_SSL",
        "confluent.topic.ssl.endpoint.identification.algorithm": "https",
        "confluent.topic.sasl.mechanism"                       : "PLAIN",
        "confluent.topic.request.timeout.ms"                   : "20000",
        "confluent.topic.retry.backoff.ms"                     : "500"
        }'
```
