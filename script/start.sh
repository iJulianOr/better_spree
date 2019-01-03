#!/bin/bash

bundle check || bundle install
rm -f tmp/pids/server.pid
yarn install --check-files
bundle exec puma -C config/puma.rb
