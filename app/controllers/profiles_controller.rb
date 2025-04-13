class ProfilesController < ApplicationController
  before_action :authenticate_user!# ログインしていない場合はログイン画面にリダイレクトするdeviseのメソッド
  before_action :set_user, only: [ :show ]# showアクションの前にユーザーを取得

  def show
  end

  def edit
    @user = current_user# current_userも現在のログインしているユーザ情報を取得するdeviseのメソッド
  end

  def update
    @user = current_user
    if @user.update(user_params)
      # 更新成功時：プロフィール表示ページにリダイレクトしてフラッシュメッセージを表示
      redirect_to profile_path(@user), notice: "プロフィールを編集しました。"
    else
      render :edit
    end
  end

  private

  # URLのIDパラメータからユーザーを取得するメソッド
  def set_user
    @user = User.find(params[:id])
  end

  # 安全にパラメータを扱うためのStrongParametersメソッド
  # フォームから送信された値のうち、許可するフィールドのみを指定
  def user_params
    params.require(:user).permit(:nickname, :bio, :daily_goal, :avatar)
  end
end
