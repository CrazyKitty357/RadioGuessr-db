#!/bin/bash

cd /home/user/projects/web/radioguessr/db || exit 1

first_entry=$(jq '.[0]' new.json)
entry_date=$(jq -r '.[0].date' new.json)

if [ "$first_entry" = "null" ]; then
    DISPLAY=:0 notify-send -a radioguessrWarn "NO DATA WAS FOUND FOR TODAY'S RADIOGUESSR PLEASE ADD DATA TO IT NOW"
    exit 0
fi

jq '.[1:]' new.json > tmp_new.json && mv tmp_new.json new.json
jq --argjson entry "$first_entry" '. + [$entry]' stations.json > tmp_stations.json && mv tmp_stations.json stations.json

echo "entry moved to bottom of stations.json"
DISPLAY=:0 notify-send "entry moved to bottom of stations.json"

git add .
git commit -m "added $entry_date"
git push
