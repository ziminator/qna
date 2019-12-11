require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should have_many(:links).dependent(:destroy) }
  it { should belong_to :user }
  it { should have_db_index :question_id }
  it { should have_db_index :user_id }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#best!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answers) { create_list(:answer, 3, question: question, user: user) }

    before(:each) do
      answers[0].best!
      answers[0].reload
    end

    it 'should make answer the best' do
      expect(answers[0]).to be_best
    end

    it 'should change the best answer' do
      expect(answers[1]).to_not be_best
      expect(answers[0]).to be_best
    end

    it 'only one answer can be the best' do
      expect(question.answers.best.count).to eq 1
    end

    it 'best answer is in list' do
      third_answer = answers.third
      third_answer.best!
      expect(Answer.best.first).to eq third_answer
      expect(question.answers).to eq([answers.third, answers.first, answers.second])
    end
  end
end
