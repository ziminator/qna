class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true, url: true

  GIST_REGEXP = /^https:\/\/gist\.github\.com\/\w+\/\w+/i

  def gist_body
    gist_id = self.url.split('/').last
    GistService.new(gist_id).call
  end

  def gist?
    self.url.match?(GIST_REGEXP)
  end
end
