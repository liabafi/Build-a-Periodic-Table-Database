#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_RESULT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
  else
    ELEMENT_RESULT=$($PSQL "SELECT * FROM elements WHERE symbol='$1' OR name='$1'")
  fi

  if [[ -z $ELEMENT_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo $ELEMENT_RESULT | while read ATOMIC_NUMBER BAR ELEMENT_SYMBOL BAR ELEMENT_NAME
    do
      PROPERTY_RESULT=$($PSQL "SELECT * FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      echo $PROPERTY_RESULT | while read ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE_ID
      do
        TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
        echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $(echo $TYPE | sed -r 's/^ *| *$//g'), with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    done
  fi
else
  echo Please provide an element as an argument.
fi
