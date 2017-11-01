#!/bin/bash

main() {
  . scripts/setup_jasmine.sh
  npm install
  bundle install
  bundle exec rake
}

main
