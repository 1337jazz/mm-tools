#!/bin/bash

profile="mm-stage"
cluster_name="marketmate-stage"
service_name="web-portfolio-pages"

# Get the task ID of the first running task for the specified service
task_arn=$(aws ecs list-tasks --cluster $cluster_name --service-name $service_name --profile $profile --query "taskArns[0]" --output text)
task_id=$(basename $task_arn)

# Get the container name from the task description
container_name=$(aws ecs describe-tasks --cluster $cluster_name --tasks $task_id --profile $profile --query "tasks[0].containers[0].name" --output text)

aws ecs execute-command \
  --cluster $cluster_name \
  --task $task_id \
  --container $container_name \
  --command "/bin/sh" \
  --profile $profile \
  --interactive

