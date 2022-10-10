curl -i -X PUT -H  "Content-Type:application/json" \
    http://localhost:8083/connectors/source-debezium-mysql-01/config \
    -d '{
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "database.hostname": "mysql",
    "database.port": "3306",
    "database.user": "debezium",
    "database.password": "dbz",
    "database.server.name": "asgard",
    "database.history.kafka.bootstrap.servers": "pkc-ymrq7.us-east-2.aws.confluent.cloud:9092",
    "database.history.kafka.topic": "dbz_dbhistory.asgard-01",
    "database.history.consumer.security.protocol": "SASL_SSL",
    "database.history.consumer.ssl.endpoint.identification.algorithm": "https",
    "database.history.consumer.sasl.mechanism": "PLAIN",
    "database.history.consumer.sasl.jaas.config": "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"SEZFKI6NULHDRSGL\" password=\"tb6Zm2xLa2VKZstGvwm1U2t6xuV/YNTLp3WDS1D6/uSJNEp4Hu/SwXSIjv0jUJRg\";",
    "database.history.producer.security.protocol": "SASL_SSL",
    "database.history.producer.ssl.endpoint.identification.algorithm": "https",
    "database.history.producer.sasl.mechanism": "PLAIN",
    "database.history.producer.sasl.jaas.config": "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"SEZFKI6NULHDRSGL\" password=\"tb6Zm2xLa2VKZstGvwm1U2t6xuV/YNTLp3WDS1D6/uSJNEp4Hu/SwXSIjv0jUJRg\";",
    "table.whitelist":"demo.customers",
    "decimal.handling.mode":"double",
    "transforms": "unwrap,addTopicPrefix",
    "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
    "transforms.addTopicPrefix.type":"org.apache.kafka.connect.transforms.RegexRouter",
    "transforms.addTopicPrefix.regex":"(.*)",
    "transforms.addTopicPrefix.replacement":"mysql-01-$1"
    }'