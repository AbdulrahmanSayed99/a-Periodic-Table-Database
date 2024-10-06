#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else 
if [[ $1  =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number= $1")
else 
    ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1' OR symbol='$1'")
fi
if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
else
DATABASE=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) WHERE atomic_number=$ELEMENT ORDER BY atomic_number")
  echo "$DATABASE" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE_ID
  do
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
if (( ELEMENT == ATOMIC_NUMBER )) 
  then 
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
fi
  done
fi
fi