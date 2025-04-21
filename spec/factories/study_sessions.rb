FactoryBot.define do
  factory :study_session do
    # 関連付け（UserとStudySessionの関係）
    association :user # 自動的に:userファクトリを使ってユーザーを作成
    
    # 基本情報
    start_time { Time.current } # 現在時刻を開始時間に設定
    completed { false } # デフォルトでは未完了
    
    # トレイトの定義
    trait :completed do
      completed { true }
      end_time { Time.current + 25.minutes } # 25分後を終了時間に設定
      duration { 25 } # 25分の勉強時間
    end
    trait :today do
      start_time { Time.current } # 今日の日付
    end   
    trait :yesterday do
      start_time { 1.day.ago } # 昨日の日付
    end  
    trait :this_week do
      start_time { 3.days.ago } # 今週の日付
    end
    
    # トレイトを組み合わせたファクトリ
    factory :completed_session do
      completed # completedトレイトを適用
    end
    
    factory :today_completed_session do
      completed # completedトレイトを適用
      today    # todayトレイトを適用
    end
  end
end