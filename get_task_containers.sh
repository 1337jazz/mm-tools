#!/bin/bash

profile="mm-prod"
cluster_name="marketmate-prod"
service_name="service-mda-external-live"
task_id="daad09c5cb36436789f87027c1cd138a" # Replace with your actual task ID

aws ecs describe-tasks --cluster $cluster_name --tasks $task_id --profile $profile
