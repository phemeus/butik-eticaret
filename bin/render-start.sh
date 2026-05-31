#!/usr/bin/env bash
set -o errexit

export RAILS_ENV=production
export RACK_ENV=production

bundle exec rails db:prepare
bundle exec rails db:seed
exec bundle exec puma -C config/puma.rb
