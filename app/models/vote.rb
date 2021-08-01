class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :score, presence: true, inclusion: { in: [1, -1] }
end
