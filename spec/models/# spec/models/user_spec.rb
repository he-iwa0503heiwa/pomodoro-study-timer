require "rails_helper"

RSpec.describe User, type: :model do
  describe 'userとstudysessionの関連付け検証' do
    it { should have_many(:study_sessions).dependent(:destroy) }#ユーザが複数のセッションを持ち、ユーザが削除されたらセッションもすべて削除されるか。
    it { should have_one_attached(:avatar) }#一人のユーザーに対して一つのアバター画像
  end
  
  describe 'バリデーション' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end
  
  describe '勉強時間統計' do
    let(:user) { create(:user) }
    
    before do
      # 今日のセッション
      create(:today_completed_session, user: user, duration: 25)
      create(:today_completed_session, user: user, duration: 25)
      
      # 今週のセッション（昨日）
      create(:completed_session, user: user, duration: 50, start_time: 1.day.ago)
      
      # 先週のセッション
      create(:completed_session, user: user, duration: 100, start_time: 8.days.ago)
    end
    
    it '今日の合計時間' do
      today_sessions = user.study_sessions.today.completed
      expect(StudySession.total_duration_for(today_sessions)).to eq(50)#25+25
    end
    
    it '今週の勉強時間' do
      week_sessions = user.study_sessions.this_week.completed
      expect(StudySession.total_duration_for(week_sessions)).to eq(100) #25+25+50
    end
    
    it 'すべての合計勉強時間' do
      all_sessions = user.study_sessions.completed
      expect(StudySession.total_duration_for(all_sessions)).to eq(200) #25+25+50+100
    end
  end
end