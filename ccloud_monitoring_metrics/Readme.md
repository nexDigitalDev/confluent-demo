# Monitoring-on-confluent-cloud

The main objective of this project is to provide key steps to configure Prometheus to scarify metrics from the Confleunt cloud API metric endpoint and work as a data source for Grafana which is a dashboard creation and visualization tool. 
![image](https://user-images.githubusercontent.com/103249046/178447755-ba18bcb5-6818-45f2-ae46-bea2cd863cb6.png)

## Requirements:
- A Confluent account cloud and organization 
- Confluent cli 
- Confluent cloud cluster 
- Docker 

## Steps : 

### Step1: Create  Cluster API KEY 

First , lets strat by creating  a service account and give it the role of a Metrics Viewer either by creating it manually on coufluent cloud or by y using the following cli command. 
1-Login into confluent cloud account , this step requieres the confluent cloud account username and password .

```bash
$confluent login --save
```
2-Create the service account ( the descriptor field is optionnal).

```bash
$confluent iam service-account create MetricsImporter --description "A  service account to import Confluent Cloud metrics into Prometheus"
```
3-Add the MetricsViewer role to the service account, replace the $sa-id by your service account ID ( looks like  sa-d91gmd)

```bash
$confluent iam rbac role-binding create --role MetricsViewer --principal User:$sa-id
```

4-Now , let's assign an api key to our Metrics viewer service account . The cluster API Key gives us acces to retrieve metrics from the confluent cloud API metrics . You can create it directly on confluent cloud manualy or by using the following cli command . 

```bash
$confluent api-key create --resource cloud --service-account $sa-id
```
### Step2: Clone this repo 

```bash
git clone https://github.com/confluentinc/jmx-monitoring-stacks
cd jmx-monitoring-stacks/ccloud-prometheus-grafana
```

### Step3: 

Edit the env_variables.env file by adding : this depends on the ressource you want to monitor 
- Cluster ID
- Cluster API KEy and password 
- Ksql cluster ID
- Schema registry ID
- Connector ID 
To find the resource IDs for these components, we can run the following commands on the Confluent CLI or find them directly on confluent cloud :
Cluster ID : replace $env-ID by your environement ID
```bash
$ confluent environment use $env-ID
$ confluent kafka cluster list
```
Ksql cluster ID :
```bash
$ confluent ksql cluster list
```
Schema registry ID :
```bash
$ confluent schema-registry cluster describe
```
Connector ID :replace $clus-ID by your cluster ID
```bash
$ confluent connect list --cluster $clus-ID
```
### Step4: 
Run the start file  
```bash
$ ./start.sh
```
### Step5: 
- Open Grafana endpoint :  http://localhost:3000/
- Login : username : admin 
          password : password 
- Select  Browse Dashboards
![image](https://user-images.githubusercontent.com/103249046/178491682-7a39c322-7fe4-4cee-90a5-693a45a0ecd5.png)
- Open Confluent Cloud Dashboard to find a similar dashboard :
![image](https://user-images.githubusercontent.com/103249046/178491960-72db46d8-16f0-41ff-94f3-95e57df753f0.png)



