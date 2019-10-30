require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'Author?' do
    let(:user) { create(:user) }
    let(:any_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'current user is author' do
      expect(user).to be_author(question)
    end

    it 'current user not an author' do
      expect(any_user).to_not be_author(question)
    end
  end
end
