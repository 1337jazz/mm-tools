#!/bin/bash

# Usage: ./remove.sh <traderId> <positionEventId> <token>
if [ $# -ne 3 ]; then
  echo "Usage: $0 <traderId> <positionEventId> <token>"
  exit 1
fi

traderId="$1"
positionEventId="$2"
token="$3"

curl -i -X DELETE "https://api.marketmate.se/trading-feed/${traderId}/position-events/${positionEventId}" \
  -H "Authorization: Bearer ${token}"
