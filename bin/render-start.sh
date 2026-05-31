#!/usr/bin/env bash
set -o errexit

export RAILS_ENV=production
export RACK_ENV=production
export RAILS_MASTER_KEY="${RAILS_MASTER_KEY:-037da71d8629692af76e1ca4da00a4f3}"

if [ -z "${DATABASE_URL:-}" ]; then
  echo ""
  echo "HATA: DATABASE_URL tanimli degil."
  echo "Render -> Web Service -> Environment -> DATABASE_URL = Postgres Internal URL"
  echo ""
  exit 1
fi

echo "==> db:prepare..."
bundle exec rails db:prepare

echo "==> db:seed..."
bundle exec rails db:seed

echo "==> puma..."
exec bundle exec puma -C config/puma.rb
