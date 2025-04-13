class StudySession < ApplicationRecord
  belongs_to :user

  # バリデーション
  validates :start_time, presence: true
  validates :duration, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  # スコープ（特定の条件で絞り込むためのショートカットを:completedとかでメソッドとして作ることできる）
  scope :completed, -> { where(completed: true) }
  scope :today, -> { where("start_time >= ?", Time.zone.now.beginning_of_day) }
  scope :this_week, -> { where("start_time >= ?", Time.zone.now.beginning_of_week) }

  # スコープの結果を引数として、合計学習時間を計算するクラスメソッド
  def self.total_duration_for(scope)
    scope.sum(:duration) || 0
  end
end
