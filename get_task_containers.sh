#!/bin/bash

profile="mm-prod"
cluster_name="marketmate-prod"
service_name="service-mda-external-live"
task_id="0de1833cf46d4bd4970f0f8c7bf62d1c" # Replace with your actual task ID

aws ecs describe-tasks --cluster $cluster_name --tasks $task_id --profile $profile
