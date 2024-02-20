#!/bin/bash

set -eu

# If 'debug' is in your Gemfile:
# bundle exec rdbg --open -n -c -- bundle exec rails server -p 3000 -b 0.0.0.0

# If 'debug' is not in your Gemfile:
rdbg --open -n -c -- bundle exec rails server -p 3000 -b 0.0.0.0
