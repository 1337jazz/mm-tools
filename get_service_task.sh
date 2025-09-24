#!/bin/bash

profile="mm-prod"
cluster_name="marketmate-prod"
service_name="service-mda-external-live"

aws ecs list-tasks --cluster $cluster_name --service-name $service_name --profile $profile
