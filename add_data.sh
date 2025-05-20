#!/bin/bash

first_entry=$(jq '.[0]' new.json)

entry_date=$(jq -r '.[0].date' new.json)

if [ "$first_entry" = "null" ]; then
    notify-send -a radioguessrWarn "NO DATA WAS FOUND FOR TODAY'S RADIOGUESSR PLEASE ADD DATA TO IT NOW"
    exit 0
fi

jq '.[1:]' new.json > tmp_new.json && mv tmp_new.json new.json
jq --argjson entry "$first_entry" '. + [$entry]' stations.json > tmp_stations.json && mv tmp_stations.json stations.json

echo "entry moved to bottom of stations.json"
notify-send "entry moved to bottom of stations.json"

git add /home/user/projects/web/radioguessr/db/.
git commit -m "added $entry_date" /home/user/projects/web/radioguessr/db/.
git push