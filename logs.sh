#!/bin/bash
# Tail ECS logs for a service, filtering out health checks and noise, pretty-printing JSON
# Requires: unbuffer (sudo pacman -S expect), jq

SERVICE=${1:?Usage: $0 <service> <profile>}
PROFILE=${2:?Usage: $0 <service> <profile>}

FILTER='.msg != "finished call" and .["grpc.method"] != "Check"'

# If the --debug flag is not passed, filter out debug logs
[[ "$*" == *"--debug"* ]] || FILTER="$FILTER and .level != \"DEBUG\""

FILTER="select($FILTER)"

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

# If the --raw flag is passed, don't strip any fields
[[ "$*" == *"--raw"* ]] && STRIP='.'

unbuffer aws logs tail /ecs/$SERVICE --follow --profile $PROFILE \
  | jq -Rc 'split(" ")[2:] | join(" ") | fromjson? | '"$FILTER"' | '"$STRIP"
