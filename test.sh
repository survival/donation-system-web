#!/bin/bash

. credentials/.env_test
. credentials/.email_server
bundle exec rake
