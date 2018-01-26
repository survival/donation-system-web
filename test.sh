#!/bin/bash
npm run compile
. credentials/.email_server
. credentials/.env_test
bundle exec rake
