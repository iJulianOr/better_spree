#!/bin/bash

bundle check || bundle install
rm -f tmp/pids/server.pid
yarn install --check-files
./bin/webpack-dev-server --inline true
