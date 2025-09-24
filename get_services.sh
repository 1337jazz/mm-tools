#!/bin/bash

profile="mm-prod"
cluster_name="marketmate-prod"

aws ecs list-services --cluster $cluster_name --profile $profile
