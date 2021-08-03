class Answer < ApplicationRecord

  include FilesAttachable
  include LinksAttachable
  include Votable

  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def set_the_best
    self.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.award&.update!(user: author)
    end
  end
end
