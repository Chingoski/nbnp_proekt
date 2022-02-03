#!/bin/bash
while IFS="," read event_id game_id time_value event
do
       	formated_event=$(echo "$event"|tr -d '\n')
	MULTI="MULTI\n"
        HMSET="HMSET events:$event_id game_id $game_id time \"$time_value\" event \"$formated_event\"\n"
	SADD="SADD all-events $event_id\n"
	GAME_EVENTS="SADD events:game:$game_id $event_id\n"
        EXEC="EXEC"
        $(echo -e "$MULTI$HMSET$SADD$GAME_EVENTS$EXEC" | redis-cli --pipe )
done < <(tail -n +2 events.csv)
