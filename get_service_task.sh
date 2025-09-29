#!/bin/bash

profile="mm-prod"
cluster_name="marketmate-prod"
service_name="service-mda-external-delayed"

task_arn=$(aws ecs list-tasks --cluster $cluster_name --service-name $service_name --profile $profile --query "taskArns[0]" --output text)
task_id=$(basename $task_arn)
