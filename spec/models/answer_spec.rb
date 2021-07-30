require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :author }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'has many attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#set_the_best method' do
    let(:user) { create :user }
    let!(:question) { create :question, author: user }
    let!(:answer) { create :answer, question: question, author: user }
    let!(:answer1) { create :answer, question: question, author: user }

    context 'award' do
      let!(:award) { create :award, question: question }

      it 'take assignes award to user' do
        answer.set_the_best

        expect(award.user).to eq answer.author
      end
    end

    it 'sets the best answer attribute' do
      answer.set_the_best

      expect(answer).to be_best
    end

    it 'verifies that only 1 answer has best attribute' do
      answer.set_the_best

      expect(answer1).to_not be_best
    end

    it 'shows the best answer first' do
      answer1.set_the_best

      expect(Answer.all.sort_by_best.first).to eq answer1
    end
  end
end
