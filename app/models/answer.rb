class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  default_scope -> { order('best DESC, created_at') }
  scope :best, -> { where(best: true) }

  def best!
    best_answer = question.answers.find_by(best: true)

    transaction do
      best_answer.update!(best: false) if best_answer
      update!(best: true)
    end
  end
end
