# WIP

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