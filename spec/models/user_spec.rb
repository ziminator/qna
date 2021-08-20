require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribed_questions).through(:subscriptions) }

  it { should_not allow_value('qwerty@change.me').for(:email).on(:update) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let!(:user1) { create :user }
  let!(:user2) { create :user }
  let!(:question) { create :question, author: user1 }

  describe '.find_for_oauth' do
    let!(:user) { create :user }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#author_of?' do
    it 'confirms that user is the author' do
      expect(user1).to be_author_of(question)
    end

    it 'confirms that user is not the author' do
      expect(user2).to_not be_author_of(question)
    end
  end

  describe '#email_verified?' do
    let(:user_invalid) { create(:user, email: 'please@change.me') }
    let(:user_valid) { create(:user, email: 'please@mail.me') }

    it 'false' do
      expect(user_invalid.email_verified?).to be_falsey
    end

    it 'true' do
      expect(user_valid.email_verified?).to be_truthy
    end
  end

  describe '#subscribed_to_question?' do
    let(:user) { create :user }
    let(:question) { create :question }
    let(:user2) { create :user }

    it 'true' do
      user.subscriptions.create!(question: question)

      expect(user).to be_subscribed_to_question(question)
    end

    it 'false' do
      expect(user2).to_not be_subscribed_to_question(question)
    end
  end

  it_behaves_like 'sphinxable', User
end
