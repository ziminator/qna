class Answer < ApplicationRecord
  has_many_attached :files, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :question
  belongs_to :author, class_name: 'User'

  accepts_nested_attributes_for :links, reject_if: :all_blank

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
