#!/usr/bin/env bash
set -o errexit

echo "==> render-start.sh basladi"

export RAILS_ENV=production
export RACK_ENV=production
export RAILS_MASTER_KEY="${RAILS_MASTER_KEY:-037da71d8629692af76e1ca4da00a4f3}"

if [ -z "${DATABASE_URL:-}" ]; then
  echo "HATA: DATABASE_URL tanimli degil."
  echo "Render -> Environment -> DATABASE_URL = Postgres Internal URL ekle."
  exit 1
fi

echo "==> DATABASE_URL=tanimli"
echo "==> db:prepare..."
bundle exec rails db:prepare

echo "==> db:seed..."
bundle exec rails db:seed

echo "==> puma baslatiliyor (PORT=${PORT:-3000})..."
exec bundle exec puma -C config/puma.rb
