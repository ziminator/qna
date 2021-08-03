require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let!(:user1) { create :user }
  let!(:user2) { create :user }
  let!(:question) { create :question, author: user1 }

  describe 'User#author_of?' do
    it 'confirms that user is the author' do
      expect(user1).to be_author_of(question)
    end

    it 'confirms that user is not the author' do
      expect(user2).to_not be_author_of(question)
    end
  end
end
