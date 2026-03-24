#!/bin/bash

json=$(curl -s https://api.marketmate.se/trading-feed/widget/history?country=FI\&page=1&items_per_page=8)
echo "$json" | jq ".positions.[] | {id, name: .instumentName, traderId, entryPrice}" 
