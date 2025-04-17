#!/usr/bin/env bash
# exit on error
set -o errexit

# Bundlerの凍結モードを解除
bundle config set frozen false
bundle install

# アセットのプリコンパイルをスキップするオプション
export RAILS_ENV=production
export DISABLE_DATABASE_ENVIRONMENT_CHECK=1

# データベースのセットアップ
bundle exec rake db:migrate

# 最小限のアセットコンパイル
bundle exec rake assets:clean
bundle exec rake assets:precompile SECRET_KEY_BASE_DUMMY=1