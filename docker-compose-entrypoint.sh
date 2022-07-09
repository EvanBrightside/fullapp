#!/bin/bash
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

yarn install
# bundle exec rake db:migrate db:seed

exec bundle exec "$@"
