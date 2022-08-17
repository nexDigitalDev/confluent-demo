#!/bin/bash

source .env
envsubst docker-compose.yml.edit > docker-compose.yml
docker-compose up -d