class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "answer_for_question_#{data['question_id']}"
  end
end
