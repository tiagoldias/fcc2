#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi



# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART WITH 1");
echo $($PSQL "ALTER SEQUENCE games_game_id_seq RESTART WITH 1");

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  # inserting teams
  
  if [[ $WINNER != "winner" ]]
  then
      WINNER_IS_ALREADY=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
      if [[ -z  $WINNER_IS_ALREADY  ]]
      then
        echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      fi
  fi

  if [[ $OPPONENT != "opponent" ]]
  then
      OPPONENT_IS_ALREADY=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
      if [[ -z  $OPPONENT_IS_ALREADY  ]]
      then
        echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      fi
  fi


done


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ $YEAR != 'year' ]]
  then
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  fi
done
