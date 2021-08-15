require 'rails_helper'

RSpec.describe Services::NewAnswerNotifier do
  let(:users) { create_list :user, 3 }
  let(:user) { create :user }
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }
  subject { Services::NewAnswerNotifier.new(answer) }

  before do
    users.each do |u|
      answer.question.subscriptions.create(user: u)
    end

    users.push(question.author)
  end

  it 'sends email to subscribers' do
    users.each { |user| expect(NewAnswerNotifierMailer).to receive(:notify_about_new_answer).with(user, answer).and_call_original }

    subject.send_notification
  end
end
