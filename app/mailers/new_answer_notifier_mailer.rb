class NewAnswerNotifierMailer < ApplicationMailer
  def notify_about_new_answer(user, answer)
    @answer = answer
    mail to: user.email,
         subject: 'A new answer posted in your question!'
  end
end
