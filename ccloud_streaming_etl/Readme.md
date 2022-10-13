### Confluent cloud as a streaming etl:

Our use case involves building a streaming etl using only Confluent Cloud, Kafka Connect and KSQL:
![image](https://user-images.githubusercontent.com/103249046/195542481-beef53d0-6af3-4078-b91d-920ea888a9bc.png)

<p>Unlike traditional etls based on batch processes that typically result in delays in data availability for our company's applications, streaming etls extract, process data as events in real time, and make it highly available.
Confluent cloud is built on top of Kafka which is a distributed, scalable, fault-tolerant streaming platform providing low-latency pub-sub messaging coupled with native storage and stream processing capabilities. Integrating Kafka with external systems is simple with Kafka Connect, which is part of Apache Kafka. KSQL is an SQL streaming engine for Apache Kafka, which allows you to create stream processing applications at scale, written using a familiar SQL interface.</p>
<p>By using Kafka as the core of our architecture, we are not only able to create a streaming etl but also to distribute this processed and enriched data to different applications at the same time. 
For the purposes of our use case, we will have two data sources: Data provided by a table created in Mysql that we will send to confluent cloud using a self-managed connector as well as data generated using the Datagen connector available on the confluent cloud. 
Then we will use Ksql to perform filtering, join, aggregation operations on these event streams provided by different sources in real time. Finally, we will simply stream our processed data into Elasticsearch to enable fast search and analytical view of our data in near real-time.</p>

## Architecture : 
![image](https://user-images.githubusercontent.com/103249046/195542579-237afe5c-34e2-40d4-9880-2f16ae946d5f.png)


-Confluent cloud : 2 cluster (ksql cluster for data processing and a dev cluster)
                                             One connector (the Datagen connector )
-Docker : mysql , kafka connect , elasticsearch , kibana containers 

## Input data : 

  -DatagenConnector  : Rating 
  | Rating_id |  User_id  |   Stars  |  Route_id |Rating_time | Channel   | Message  |
  | --------- | --------- | ---------| --------- | ---------- | --------- |--------- |
                                 
                                                           
   -Mysql table:CUSTOMERS
  | Id |  First_name  | Last_name |   Email   |  Gender  |  Club status   | Comments  |
  | -- | ------------ | --------- | --------- | -------- | -------------- |---------- |
                            
## Steps : 
1. Create confluent cloud env ,cluster , api keys  and set up schema registry .
2. Edit and Run the docker compose files for creation the kafka connect , mysql , elasticsearch and kibana containers . 

```bash
 #mysql , elasticsearch and kibana
 docker-compose -f docker_compose.yml up 
 #Kafka connect 
 docker-compose -f docker-compose.yml
 ```
3. Configure self managed debezium source  connector : 
```bash
./run.sh 
 ```
4. Launch the datagen connectors directly from confluent cloud . 
5. Create the ksql cluster + import the topics (rating +customers ) as streams to ksql 
6. Create the streaming pipeline (customers as table)
7. Configure elastic search sink connector 

```bash
curl -s -i -X PUT -H  "Content-Type:application/json"     http://localhost:8083/connectors/sink-elastic-01/config     -d '{
            "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
            "connection.url": "http://elasticsearch7:9200",
            "type.name": "_doc",
            "topics": "mysql-01-asgard.demo.CUSTOMERS",
            "key.ignore": "true",
            "schema.ignore": "true"
            }'
```

8. Create kibana dashboards 
9. View Kibana:
http://localhost:5601/app/kibana#/dashboard/mysql-ksql-kafka-es
