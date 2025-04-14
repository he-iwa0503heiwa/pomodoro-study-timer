# app/controllers/timers_controller.rb
class TimersController < ApplicationController
  before_action :authenticate_user!

  # indexアクション：タイマーのトップ画面の動き
  def index
    # 今日の勉強時間を@today_durationに集計
    today_session = current_user.study_sessions.today.completed
    @today_duration = StudySession.total_duration_for(today_session)

    # 今週の勉強時間を@week_durationに集計
    week_session = current_user.study_sessions.this_week.completed
    @week_duration = StudySession.total_duration_for(week_session)

    # 全ての勉強時間を@total_durationに集計
    total_session = current_user.study_sessions.completed
    @total_duration = StudySession.total_duration_for(total_session)

    # 直近5回のセッション情報
    @recent_sessions = current_user.study_sessions.completed.order(created_at: :desc).limit(5)
  end

  # createアクション：スタートボタンを押した時の動き
  def create
    # current_user.study_sessionsでアソシエーションにアクセスし新しいStudySessionの作成し、下記2つのカラム設定
    @study_session = current_user.study_sessions.new(
      start_time: Time.current,
      completed: false
    )
    # javascriptと連携しAjaxリクエストに対応するため、json形式で返す。
    if @study_session.save
      render json: { id: @study_session.id, start_time: @study_session.start_time }
    else
      render json: { error: @study_session.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  # completeアクション：ストップボタンを押した時の動き
  def complete
    # セッションIDを取得
    @study_session = current_user.study_sessions.find_by(id: params[:session_id])

    if @study_session
      # 現在の時間とスタートの時間から勉強時間を算出
      end_time = Time.current
      duration = ((end_time - @study_session.start_time) / 60).round

      # 勉強時間のセッション
      today_session = current_user.study_sessions.today.completed
      week_session = current_user.study_sessions.this_week.completed
      total_session = current_user.study_sessions.completed

      # update成功したらupdate内容をjson形式で返す
      if @study_session.update(end_time: end_time, duration: duration, completed: true)
        render json: {
          success: true,
          duration: duration,
          today_total: StudySession.total_duration_for(today_session) + duration,
          week_total: StudySession.total_duration_for(week_session) + duration,
          all_time_total: StudySession.total_duration_for(total_session) + duration
        }
      else
        render json: { error: @study_session.errors.full_messages.join(", ") }, status: :unprocessable_entity
      end
    else
      render json: { error: "セッションが見つかりません" }, status: :not_found
    end
  end

  # save_progressアクション：タイマーの進捗状況を自動保存するときの動き
  def save_progress
    @study_session = current_user.study_sessions.find_by(id: params[:session_id])

    if @study_session
      elapsed_minutes = params[:elapsed_minutes].to_i

      # 経過時間と現在時刻でセッションを更新
      if @study_session.update(duration: elapsed_minutes, end_time: Time.current)
        render json: { success: true, minutes_saved: elapsed_minutes }
      else
        render json: { error: @study_session.errors.full_messages.join(", ") }, status: :unprocessable_entity
      end
    else
      render json: { error: "セッションが見つかりません" }, status: :not_found
    end
  end
end
