#!/bin/bash
# Tail ECS logs for a service, filtering out health checks and noise, pretty-printing JSON
# Requires: unbuffer (sudo pacman -S expect), jq

SERVICE=${1:?Usage: $0 <service> <profile>}
PROFILE=${2:?Usage: $0 <service> <profile>}

# The cloudwatch filter pattern to exclude health checks and finished calls, which are noisy and not useful for debugging
FILTER=$'{$.[\'grpc.method\'] != "Check" && $.msg != "finished call"}'

# The jq filter to strip out uninteresting fields from the log messages
STRIP='del(
  .protocol,
  .["grpc.method_type"],
  .["peer.address"],
  .["grpc.start_time"],
  .["grpc.time_ms"],
  .request_id,
  .["grpc.component"],
  .["grpc.service"]
)'

unbuffer aws logs tail /ecs/$SERVICE --follow --profile $PROFILE \
  --filter-pattern "$FILTER" \
  | jq -Rc 'split(" ")[2:] | join(" ") | fromjson | '"$STRIP"
