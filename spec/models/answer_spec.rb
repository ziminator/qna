require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_db_index :question_id }
  it { should have_db_index :user_id }
  it { should validate_presence_of :body }

  describe '#best!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:best_answer) { create(:answer, question: question, user: user, best: true) }
    let(:answer) { create(:answer, question: question, user: user) }

    before(:each) do
      answer.best!
      best_answer.reload
    end

    it 'should make answer the best' do
      expect(answer).to be_best
    end

    it 'should change the best answer' do
      best_answer.best!
      answer.reload

      expect(answer).to_not be_best
      expect(best_answer).to be_best
    end

    it 'only one answer can be the best' do
      expect(question.answers.best.count).to eq 1
    end

    it 'best answer is in list' do
      best_answer.best!
      question.reload
      expect(best_answer).to eq best_answer
    end
  end
end
