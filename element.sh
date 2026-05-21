#!/bin/bash

# connexion to the database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


# input validation

INPUT=$1

if [[ -z $INPUT ]]
then
  # No input insert
  echo "Please provide an element as an argument."
else
  # Input insert
  #echo "You insert $INPUT"
  if [[ $INPUT =~ ^[0-9]+$ ]]
  then
      CONDITION="e.atomic_number = $INPUT"
  else
     CONDITION="e.symbol = '$INPUT' OR e.name = '$INPUT'"
  fi
  #echo $CONDITION

  RESULT=$($PSQL "
    SELECT e.atomic_number, e.name, e.symbol,
           t.type,
           p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
    FROM elements e
    JOIN properties p USING(atomic_number)
    JOIN types t USING(type_id)
    WHERE $CONDITION;
  ")
 

  if [[ -z $RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$RESULT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
    do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi



# delete the non existent element, whose atomic_number is 1000, from the table elements
$PSQL "delete from elements where atomic_number=1000;" > /dev/null 2>&1 # cause de soucis d'erreur le code ne marchait pas 

# delete the non existent element, whose atomic_number is 1000, from the table properties
$PSQL "delete from properties where atomic_number=1000;" > /dev/null 2>&1
# Removal type column from table properties
$PSQL "alter table properties drop column IF EXISTS type;" > /dev/null 2>&1
fi

                                                                                  