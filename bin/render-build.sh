#!/usr/bin/env bash
set -o errexit

# Asset derlemesi Rails environment yükler; build aşamasında SECRET_KEY_BASE şart.
export SECRET_KEY_BASE="${SECRET_KEY_BASE:-$(openssl rand -hex 64)}"

bundle install
bundle exec rails assets:precompile
