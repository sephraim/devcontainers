#!/bin/bash

set -eu

if [ "$RAILS_ENV" = "development" ] && which rdbg >/dev/null 2>&1; then
  # Run the server + debugger if it's installed and if RAILS_ENV=development
  bundle exec rdbg --open -n -c -- bin/rails server -p 3000 -b 0.0.0.0
else
  # Otherwise just run the server
  bin/rails server -p 3000 -b 0.0.0.0
fi
