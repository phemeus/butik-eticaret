#!/usr/bin/env bash
set -o errexit

# Build aşamasında credentials/DB gerekmez (Render resmi Rails 8 yaklaşımı).
export SECRET_KEY_BASE_DUMMY=1
export DISABLE_DATABASE_ENVIRONMENT_CHECK=1

bundle install
bundle exec rails assets:precompile

# Free plan'de preDeployCommand çalışmaz; migration/seed build'de yapılır.
bundle exec rails db:prepare
bundle exec rails db:seed
