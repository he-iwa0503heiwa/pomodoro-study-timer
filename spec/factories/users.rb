FactoryBot.define do
  factory :user do
    # 基本情報
    email { Faker::Internet.email } # Fakerを使ってランダムなメールアドレスを生成
    password { 'password123' } # テスト用のパスワード
    password_confirmation { 'password123' } # 確認用パスワード
    
    # トレイト（再利用するための部品）
    trait :with_nickname do
      nickname { Faker::Name.name } # ランダムな名前を生成
    end
    trait :with_bio do
      bio { Faker::Lorem.paragraph } # ランダムな段落を生成
    end
    trait :with_daily_goal do
      daily_goal { rand(30..120) } # 30〜120分のランダムな目標時間
    end
    
    # 特定のユースケースに対応させるための複数のトレイトを組み合わせた完全なユーザーファクトリ
    factory :complete_user do
      nickname { Faker::Name.name }
      bio { Faker::Lorem.paragraph }
      daily_goal { rand(30..120) }
    end
  end
end