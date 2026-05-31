#!/usr/bin/env bash
set -euo pipefail

echo "==> rbenv kurulumu (WSL)"
if [ ! -d "$HOME/.rbenv" ]; then
  git clone https://github.com/rbenv/rbenv.git "$HOME/.rbenv"
  git clone https://github.com/rbenv/ruby-build.git "$HOME/.rbenv/plugins/ruby-build"
fi

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"

if ! grep -q 'rbenv init' "$HOME/.bashrc"; then
  cat >> "$HOME/.bashrc" <<'EOF'

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"
EOF
fi

if ! rbenv versions --bare | grep -qx '3.3.0'; then
  echo "==> Ruby 3.3.0 derleniyor (ilk seferde 5-10 dk sürebilir)"
  rbenv install 3.3.0
fi

rbenv global 3.3.0
gem install bundler --no-document

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR"

echo "==> Bağımlılıklar"
bundle install

echo "==> PostgreSQL"
if command -v pg_isready >/dev/null 2>&1; then
  sudo service postgresql start || true
  if ! psql -lqt 2>/dev/null | cut -d \| -f 1 | grep -qw butik_eticaret_development; then
    createdb butik_eticaret_development 2>/dev/null || sudo -u postgres createdb butik_eticaret_development
  fi
fi

echo "==> Veritabanı"
bundle exec rails solid_queue:install 2>/dev/null || true
bundle exec rails db:prepare
bundle exec rails db:seed

echo ""
echo "Hazır! Sunucuyu başlatmak için:"
echo "  cd $PROJECT_DIR && bundle exec rails server"
