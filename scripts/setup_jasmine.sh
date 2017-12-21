#!/bin/bash

JASMINE_URL="https://github.com/jasmine/jasmine/releases/download"
JASMINE_VERSION="v2.8.0"
JASMINE_ZIPFILE="jasmine-standalone-2.8.0.zip"
LAST_JASMINE_RELEASE="$JASMINE_URL/$JASMINE_VERSION/$JASMINE_ZIPFILE"

TEMP_DIRECTORY="temp"
JS_DIRECTORY="public/js"

create_temp_directory() {
  echo "Creating $TEMP_DIRECTORY ..."
  if [ ! -d $TEMP_DIRECTORY ]; then
    mkdir -p $TEMP_DIRECTORY;
  fi
}

download_jasmine_standalone() {
  echo "Fetching $LAST_JASMINE_RELEASE ..."
  WGET_EXIT_CODE=0
  ( cd $TEMP_DIRECTORY && wget -o wget.log $LAST_JASMINE_RELEASE ) || WGET_EXIT_CODE="$?"
  echo done
}

unzip_jasmine() {
  echo "Unziping $LAST_JASMINE_ZIPFILE ..."
  UNZIP_EXIT_CODE=0
  ( cd $TEMP_DIRECTORY && unzip $JASMINE_ZIPFILE ) || UNZIP_EXIT_CODE="$?"
  echo done
}

unzip_with_error_check() {
  if [ "$WGET_EXIT_CODE" == 0 ]
  then
    unzip_jasmine
  else
    echo "The errors were:"
    more "$TEMP_DIRECTORY/wget.log"
  fi
}

move_jasmine() {
  echo "Moving $LAST_JASMINE_ZIPFILE to $JS_DIRECTORY ..."
  if [ -d "$JS_DIRECTORY/lib" ]; then
    rm -rf "$JS_DIRECTORY/lib"
  fi
  mv "$TEMP_DIRECTORY/lib" $JS_DIRECTORY;
}

move_with_error_check() {
  if [ "$UNZIP_EXIT_CODE" == 0 ]
  then
    move_jasmine
    rm -rf temp
  else
    echo "Errors unzipping"
  fi
}

main() {
  create_temp_directory
  download_jasmine_standalone
  unzip_with_error_check
  move_with_error_check
}

main
