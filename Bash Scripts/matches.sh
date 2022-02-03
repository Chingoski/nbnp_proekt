#!/bin/bash
while IFS="," read game_id home_team away_team date year hour_start attendance venue status home_score away_score home_possesion away_possesion home_shots away_shots home_fouls away_fouls home_yellow_cards away_yellow_cards home_red_cards away_red_cards home_offsides away_offsides home_corners away_corners home_saves away_saves
do
  MULTI="MULTI\n"

  HMSET="HMSET matches:#$game_id home_team \"$home_team\" away_team \"$away_team\" date \"$date\" year $year hour_start \"$hour_start\" attendance \"$attendance\" venue \"$venue\" status \"$status\" home_score $home_score away_score $away_score home_possesion \"$home_possesion\" away_possesion \"$away_possesion\" home_shots \"$home_shots\" away_shots \"$away_shots\" home_fauls $home_fouls away_fouls $away_fouls home_yellow_cards $home_yellow_cards away_yellow_cards $away_yellow_cards home_red_cards $home_red_cards home_offsides $home_offsides away_offsides $away_offsides home_saves $home_saves away_saves $away_saves\n"
  SADD="SADD all-matches #$game_id\n"
  HOME_YELLOW="${home_yellow_cards:-0}"
  AWAY_YELLOW="${away_yellow_cards:-0}"
  HOME_YELLOW_CARDS="HINCRBY yellow_cards:\"$home_team\" amount $HOME_YELLOW\n"
  AWAY_YELLOW_CARDS="HINCRBY yellow_cards:\"$away_team\" amount $AWAY_YELLOW\n"
  HOME_GAMES="SADD all-matches:\"$home_team\" $game_id\n"
  AWAY_GAMES="SADD all-matches:\"$away_team\" $game_id\n"

  EXEC="EXEC"
        $(echo -e "$MULTI$HMSET$SADD$HOME_YELLOW_CARDS$AWAY_YELLOW_CARDS$HOME_GAMES$AWAY_GAMES$EXEC" | redis-cli --pipe )
done < <(tail -n +2 matches.csv)
