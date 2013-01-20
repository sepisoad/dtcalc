#!/bin/bash

SC=$(which csc)
BIN=dtcalc
BUILD_DIR=_build_
CFLAG=
PWD=$(pwd)
OBJ_FILES=
SRC_FILES=

mkdir "$BUILD_DIR"

SRC_FILES=$(ls *.scm)
for FILE in $SRC_FILES
do
    TEMP_FILE=$PWD"/$FILE"
    $SC -c $TEMP_FILE -o "$BUILD_DIR/$FILE.o"
    echo "\"$FILE\" compiled successfully"
done

OBJ_FILES=$(ls $BUILD_DIR/*.o)
$SC -o $BIN $OBJ_FILES

echo "congradulation! $APP is was built successfully"
echo "run \"dtcalc\" to use the application"
