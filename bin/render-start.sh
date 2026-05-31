#!/usr/bin/env bash
set -o errexit

echo "==> render-start.sh basladi"

export RAILS_ENV=production
export RACK_ENV=production

# Render Dashboard'da env unutulursa repodaki credentials.yml.enc acilir.
if [ -z "${SECRET_KEY_BASE:-}" ] && [ -z "${RAILS_MASTER_KEY:-}" ]; then
  export RAILS_MASTER_KEY="037da71d8629692af76e1ca4da00a4f3"
  echo "==> UYARI: RAILS_MASTER_KEY env yok, repodaki credentials kullaniliyor."
fi

echo "==> DATABASE_URL=${DATABASE_URL:+tanımlı}"
echo "==> db:prepare..."
bundle exec rails db:prepare

echo "==> db:seed..."
bundle exec rails db:seed

echo "==> puma baslatiliyor..."
exec bundle exec puma -C config/puma.rb
