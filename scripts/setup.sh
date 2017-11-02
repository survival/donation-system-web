#!/bin/bash

main() {
  . scripts/setup_jasmine.sh
  . scripts/setup_credentials.sh
  npm install
  bundle install
  bundle exec rake
}

main
