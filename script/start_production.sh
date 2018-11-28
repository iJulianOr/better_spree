#!/bin/bash

bundle check || bundle install
bundle exec unicorn_rails -p 3000 -E production
