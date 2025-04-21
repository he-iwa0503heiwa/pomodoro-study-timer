require 'spec_helper'
require 'simplecov'
SimpleCov.start 'rails' # テストカバレッジの計測を開始し、Railsプロジェクト用の設定を使用

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/rspec' # CapybaraをRSpecと統合

# Factory Bot設定
require 'factory_bot_rails'

# Shoulda Matchers設定
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec # テストフレームワークとしてRSpecを使用
    with.library :rails       # Railsライブラリと統合
  end
end

# サポートファイルをオートロード
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema! # テストデータベースのスキーマが最新かチェック
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # Factory Botのメソッドを直接使用可能に
  config.include FactoryBot::Syntax::Methods # create(:user)のように直接呼び出せるようにする
  
  # Devise用のテストヘルパー
  config.include Devise::Test::IntegrationHelpers, type: :request # sign_inヘルパーを使用可能に
  config.include Devise::Test::IntegrationHelpers, type: :system # システムテストでもsign_inを使用可能に
  
  # データベースクリーナーの設定
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation) # テスト実行前にデータベースをクリーンアップ
  end
  
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction # 通常のテストではトランザクションを使用
  end
  
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation # JavaScriptを使うテストではトランケーションを使用
  end
  
  config.before(:each) do
    DatabaseCleaner.start # 各テスト前にクリーニング開始
  end
  
  config.after(:each) do
    DatabaseCleaner.clean # 各テスト後にクリーニング実行
  end
  
  # その他の基本設定
  config.fixture_path = "#{::Rails.root}/spec/fixtures" # フィクスチャのパス
  config.use_transactional_fixtures = false # トランザクションフィクスチャを使わない（DatabaseCleanerを使うため）
  config.infer_spec_type_from_file_location! # ファイルの場所からテストタイプを推測
  config.filter_rails_from_backtrace! # バックトレースからRailsフレームワーク部分を除外
end