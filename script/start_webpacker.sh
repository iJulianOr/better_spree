#!/bin/bash

bundle check || bundle install
rm -f tmp/pids/server.pid
./bin/webpack-dev-server --inline true
