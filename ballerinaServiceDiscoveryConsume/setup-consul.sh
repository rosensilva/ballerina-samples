#!/bin/bash

STRING="Setting up consul ..."
echo ${STRING}

sudo mkdir /etc/consul.d

echo '{"service": {"name": "timeService", "tags": ["get the current time"], "port": 9093}}' \
    | sudo tee /etc/consul.d/time.json

echo '{"service": {"name": "helloService", "tags": ["say hello"], "port": 9091}}' \
    | sudo tee /etc/consul.d/hello-service.json

echo '{"service": {"name": "dateService", "tags": ["get the current date"], "port": 9092}}' \
    | sudo tee /etc/consul.d/date.json



gnome-terminal -e "ballerina run hello-service.bal"

gnome-terminal -e "ballerina run date-service.bal"

gnome-terminal -e "ballerina run time-service.bal"

./consul agent -dev -config-dir=/etc/consul.d