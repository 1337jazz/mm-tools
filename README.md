#MM-Tools

### Remove a position:

I have been messing around and this works to restore positions without manually redoing the calculations, but it's annoying. I guess Daniel had some automation set up somewhere.
get the history and find the position you want to restore with this script:
history.sh:
#!/bin/bash

json=$(curl -s https://api.marketmate.se/trading-feed/widget/history?country=SE&page=1&items_per_page=8)
echo "$json" | jq ".positions.[] | {id, name: .instumentName, traderId, entryPrice}" 
that will show the historical positions like this, you need the traderId and id  of the position
{
  "id": 3674,
  "name": "MFL SWEDA VT57",
  "traderId": "clu01k3h1004lci3no55w8n5l",
  "entryPrice": 166.19
}
{
  "id": 4205,
  "name": "MFS OMX VT1405",
  "traderId": "clu01k3h1004lci3no55w8n5l",
  "entryPrice": 691.34
}
{
  "id": 4026,
  "name": "MINI L NOV AX SG",
  "traderId": "clu01k3h1004lci3no55w8n5l",
  "entryPrice": 269.28
}
2. you need to find the id of the event from the id of the position and get the "close" event id by running this in the db:
select * from position_event where position_id = <id> AND type = "close"
3. get a token by logging in as jonas and looking in local storage for mmIdToken and copy the value
4. run the below script with the args:
remove.sh
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
example usage : remove.sh clu01k3h1004lci3no55w8n5l 11843 eyJraWQiOiJiSWVJWTEzcjV2dGpvYlVpZzc...
That should bring back the position. But something to be aware of: mmIdToken is only valid for 5 minutes, and to get a new one you can just refresh the browser. You can test in stage by changing the urls in the script to api.stage etc
