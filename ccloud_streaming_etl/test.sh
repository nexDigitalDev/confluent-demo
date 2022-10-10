 curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d '{ "name": "consumers-connector", "config": { "connector.class": "io.debezium.connector.mysql.MySqlConnector", "tasks.max": "1", "database.hostname": "mysql", "database.port": "3306", "database.user": "debezium", "database.password": "dbz", "database.server.id": "42", "database.server.name": "asgard", "database.include.list": "demo", "database.history.kafka.bootstrap.servers": "pkc-ymrq7.us-east-2.aws.confluent.cloud:9092", "database.history.kafka.topic": "dbz_dbhistory.asgard-01" } }'

curl -s "http://localhost:8083/connectors?expand=info&expand=status" | jq '. | to_entries[] | [ .value.info.type, .key, .value.status.connector.state,.value.status.tasks[].state,.value.info.config."connector.class"]|join(":|:")' | column -s : -t| sed 's/\"//g'| sort


