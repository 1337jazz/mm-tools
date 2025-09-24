#!/bin/bash

profile="mm-prod"

aws ecs list-clusters --profile $profile
