#!/bin/bash

bundle check || bundle install
rm -f tmp/pids/server.pid
bundle exec puma -C config/puma.rb
