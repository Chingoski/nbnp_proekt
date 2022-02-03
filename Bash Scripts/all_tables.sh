#!/bin/bash
while IFS="," read place team games_played wins draws losses goals_for goals_against goal_difference points year
do
    MULTI="MULTI\n"
        HMSET="HMSET tables:$team:$year wins $wins draws $draws losses $losses goals_for $goals_for goals_against $goals_against goal_difference $goal_difference points $points\n"
    SADD="SADD all-teams $team\n"
    FIRST_PLACE=""
    TOP_THREE_FINISHES=""

    if [[ $place -eq 1 ]]
    then
        FIRST_PLACE="ZINCRBY tables:first-places 1 "$team"\n"
    fi

    if [[ $place -le 3 ]]
    then
        TOP_THREE_FINISHES="ZINCRBY tables:top-three-finishes 1 "$team"\n"
    fi

    YEAR_PLACMENT="ZADD table:$year $place $team\n"
    TEAM_PLACMENT="ZADD table:$team $place $year\n"
    EXEC="EXEC"

        $(echo -e "$MULTI$HMSET$SADD$YEAR_PLACMENT$TEAM_PLACMENT$FIRST_PLACE$TOP_THREE_FINISHES$EXEC" | redis-cli --pipe )
done < <(tail -n +2 all_tables.csv)