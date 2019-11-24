require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let!(:user) { create(:user) }
  let!(:any_user) { create(:user) }

  describe 'Author question?' do
  let(:question) { create(:question, user: user) }

    it 'current user is author' do
      expect(user).to be_author(question)
    end

    it 'current user not an author' do
      expect(any_user).to_not be_author(question)
    end
  end

  describe 'Author answer?' do
    let(:answer) { create(:answer, user: user) }

    it 'current user is author of answer' do
      expect(user).to be_author(questions.answer)
    end

    it 'current user is not an author of answer' do
      expect(any_user).to_not be_author(questions.answer)
    end
  end
end
