# Terraform for Confluent Cloud

This project contains a comprehensive terraform project to deploy an infrastructure in Confluent Cloud.

The idea behind this project is to use the file *.tfvars.json as a descriptor that terraform will use for the deployment.

The current structure of the file *.tfvars.json is as follows:
```json
{
    "environment": // name of the environment (generally development, staging or production)
    "tf_runner_account_id": // the id of a service account that should be created manually and which will be used as the main account to run terraform
    "clusters": // the list of clusters to create divided into 3 blocks: basic, standard and dedicated, which corresponds to the type of the cluster that will be deployed
    {
        "basic": {    
            "name of the cluster": {
                "zone_setting": // SINGLE_ZONE or MULTI_ZONE
                "provider": // AWS, GCP or AZURE
                "region": // Cloud region (depends on the provider)
                "topics": // list of topics that will be created in this cluster
                {
                    "name of the topic": {
                        "partitions_count":
                        "cleanup_policy": // delete or compact
                    } ...
                }
            } ...
        },
        "standard": {
            ...
        },
        "dedicated": {
            ...
        }
    }
}
```

The terraform will deploy the following elements:

- An environment
- the clusters as defined in the tfvars.json file
- a service account named "clusters_admin_{environment}"
- the rb "CloudClusterAdmin" for the clusters admin sa
- an API key in each cluster created for the clusters admin sa (currently using hashicorp vault as a secure way to save this key and all other generated key)
- a service account named "producer_{environment}"
- an API key in each cluster created for the producer sa
- a service account named "consumer_{environment}"
- an API key in each cluster created for the consumer sa
- the topics as defined in the the tfvars.json file for every cluster
- the acl "WRITE" for the producer sa to all the topics created
- the acl "READ" for the consumer sa to all the topics created

The keys are stored in the following paths:
- for Confluent Cloud API keys: `secret/ccloud/api_key/{user or service account id}`
- for clusters API keys: `secret/ccloud/cluster/{cluster name}/api_key/{user or service account id}`

## Requirements

- terraform v1.1.0 +
- a vault server v3.7.0+
- A confluent cloud account and organisation
- A service account with role binding "OrganisationAdmin"
- A Confluent Cloud API key for this service account and saved in the vault in the path `secret/ccloud/api_key/{service account id}`

## Quickstart

For Linux and Windows (wsl):

- Create a Confluent Cloud account (if not done already) in confluent.cloud
- Create a service account and API key following the steps here: https://docs.confluent.io/cloud/current/access-management/identity/service-accounts.html#create-service-accounts-ui and add the role binding "OrganisationAdmin" for it.
- save the service account id in the development.tfvars.json in the field `tf_runner_account_id`
- start a dev vault server by running:
```bash
$ vault server -dev
```
(install vault if not already)
- save the vault key in `.env` file
- save the API key created in the vault in path `secret/ccloud/api_key/{service account id}` as follows:
```json
{
    "key": <API key>,
    "secret": <API secret>
}
```
- run terraform:
```bash
$ terraform init
$ terraform apply -var-file="environment/development.tfvars.json"
```