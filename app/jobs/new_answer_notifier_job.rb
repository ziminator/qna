class NewAnswerNotifierJob < ApplicationJob
  queue_as :default

  def perform(answer)
    service = Services::NewAnswerNotifier.new(answer)
    service.send_notification
  end
end
