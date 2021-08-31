class Answer < ApplicationRecord

  include FilesAttachable
  include LinksAttachable
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :author, class_name: 'User'

  validates :body, presence: true

  after_create :notify_about_new_answer

  scope :sort_by_best, -> { order(best: :desc) }

  def set_the_best
    self.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.award&.update!(user: author)
    end
  end

  private

  def notify_about_new_answer
    NewAnswerNotifierJob.perform_later(self)
  end
end
