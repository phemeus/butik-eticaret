#!/usr/bin/env bash
set -o errexit

export RAILS_ENV=production
export RACK_ENV=production

if [ -z "${SECRET_KEY_BASE:-}" ] && [ -z "${RAILS_MASTER_KEY:-}" ]; then
  echo "HATA: Render Environment'a RAILS_MASTER_KEY veya SECRET_KEY_BASE ekleyin."
  exit 1
fi

bundle exec rails db:prepare
bundle exec rails db:seed
exec bundle exec puma -C config/puma.rb
