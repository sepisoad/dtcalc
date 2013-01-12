#!/bin/bash

SC=$(which csc)
BIN=dtcalc
CFLAG=
PWD=$(pwd)
OBJ_FILES=
SRC_FILES="main.scm
common_switches.scm 
time_switches.scm
date_switches.scm"

for FILE in $SRC_FILES
do
    TEMP_FILE=$PWD"/$FILE"
    $SC -c $TEMP_FILE
    echo "\"$FILE\" compiled successfully"
done

OBJ_FILES=$(ls *.o)
$SC -o $BIN $OBJ_FILES

echo "congradulation! $APP is was built successfully"
echo "run \"dtcalc\" to use the application"
