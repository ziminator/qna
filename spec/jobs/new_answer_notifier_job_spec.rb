require 'rails_helper'

RSpec.describe NewAnswerNotifierJob, type: :job do
  let(:service) { double 'Services::NewAnswerNotifier' }
  let(:user) { create :user }
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }

  before do
    allow(Services::NewAnswerNotifier).to receive(:new).with(answer).and_return(service)
  end

  it 'calls Services::NewAnswerNotifier#send_notification' do
    expect(service).to receive(:send_notification)
    NewAnswerNotifierJob.perform_now(answer)
  end
end
