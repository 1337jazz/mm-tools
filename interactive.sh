#!/bin/bash

profile="mm-prod"
cluster_name="marketmate-prod"
service_name="service-mda-external-live"
task_id="daad09c5cb36436789f87027c1cd138a" 
container_name="service-mda-external-live-container"

aws ecs execute-command \
  --cluster $cluster_name \
  --task $task_id \
  --container $container_name \
  --command "/bin/sh" \
  --profile $profile \
  --interactive

