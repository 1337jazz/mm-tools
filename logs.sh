#!/bin/bash

SERVICE=$1
PROFILE=$2

if [ -z "$SERVICE"  || [ -z "$PROFILE" ] ]; then
  echo "Usage: $0 <service> <profile>"
  exit 1
fi

aws logs tail /ecs/$SERVICE --follow --profile $PROFILE --filter-pattern $'{$.[\'grpc.method\'] != "Check"}'
