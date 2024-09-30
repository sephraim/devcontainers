#!/bin/bash

set -eu

if bundle show rdbg > /dev/null 2>&1; then
  # If 'rdbg' is in your Gemfile:
  bundle exec rdbg --open -n -c -- bin/rails server -p 3000 -b 0.0.0.0
else
  # If 'rdbg' is not in your Gemfile:
  rdbg --open -n -c -- bin/rails server -p 3000 -b 0.0.0.0
fi
