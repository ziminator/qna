class Link < ApplicationRecord
  belongs_to :question

  validates :name, :url, precence: true
end
