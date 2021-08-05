class Question < ApplicationRecord

  include FilesAttachable
  include LinksAttachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_one :award, dependent: :destroy

  accepts_nested_attributes_for :award, reject_if: :all_blank

  belongs_to :author, class_name: 'User'
  validates :title, :body, presence: true
end
