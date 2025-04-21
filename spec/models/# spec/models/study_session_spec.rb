require 'rails_helper'
#StudySessionのグループ化されているモデルのテスト
RSpec.describe StudySession, type: :model do
  #バリデーションのグループ化テスト
  describe 'バリデーション' do
    it { should validate_presence_of(:start_time) }
    
    context '期間が存在する場合' do
      it '0より大きい値なら有効' do
        study_session = build(:study_session, duration: 5)#期間を5としてテスト
        expect(study_session).to be_valid#有効であることを期待（5の場合は有効であるため、trueを返す）
      end  
      it '0以下なら無効' do
        study_session = build(:study_session, duration: 0)#期間を0としてテスト
        expect(study_session).not_to be_valid#無効であることを期待（0の場合無効であるため、trueを返す）
      end
    end
  end
  
  describe 'studysessionとuser関連付け検証' do
    it { should belong_to(:user) }
  end
  
  describe 'スコープ' do
    let!(:user) { create(:user) }
    let!(:completed_session) { create(:completed_session, user: user) }
    let!(:in_progress_session) { create(:study_session, user: user) }
    let!(:today_session) { create(:today_completed_session, user: user) }
    let!(:yesterday_session) { create(:completed_session, user: user, start_time: 1.day.ago) }
    let!(:this_week_session) { create(:completed_session, user: user, start_time: 2.days.ago) }
    
    describe '.completed' do
      it '完了したセッションのみ返す' do
        expect(StudySession.completed).to include(completed_session)#completedスコープは完了済みセッションを正しく取得できること
        expect(StudySession.completed).not_to include(in_progress_session)#completedスコープは未完了のセッションを取得しないこと
      end
    end
    
    describe '.today' do
      it '今日のセッションのみ返す' do
        expect(StudySession.today).to include(today_session)
        expect(StudySession.today).not_to include(yesterday_session)
      end
    end
    
    describe '.this_week' do
      it '今週のセッションのみ返す' do
        expect(StudySession.this_week).to include(today_session)
        expect(StudySession.this_week).to include(this_week_session)
      end
    end
  end
  
  describe '.total_duration_for' do
    let(:user) { create(:user) }
    
    #テスト前に実行
    before do
      create(:completed_session, user: user, duration: 25)
      create(:completed_session, user: user, duration: 50)
    end
    
    it 'calculates total duration correctly' do
      sessions = StudySession.where(user: user, completed: true)
      expect(StudySession.total_duration_for(sessions)).to eq(75)#75分とイコールになっていること
    end
    
    it 'returns 0 when no sessions exist' do
      sessions = StudySession.where(user_id: 0)
      expect(StudySession.total_duration_for(sessions)).to eq(0)#ユーザーが存在しない場合、0分となっていること
    end
  end
end