#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"

if ! rbenv versions --bare 2>/dev/null | grep -qx '3.3.0'; then
  echo "Ruby 3.3.0 kuruluyor..."
  rbenv install 3.3.0
fi

rbenv global 3.3.0
gem install bundler --no-document

PROJECT="/mnt/c/Users/Yasin/Desktop/butik-eticaret"
cd "$PROJECT"

bundle install

if command -v pg_isready >/dev/null 2>&1; then
  pg_isready >/dev/null 2>&1 || sudo service postgresql start
  createdb butik_eticaret_development 2>/dev/null || true
fi

bundle exec rails db:prepare
bundle exec rails db:seed

echo "RBENV_READY"
