class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :created_at, :updated_at, :short_body, :files
  has_many :links
  has_many :comments


  def short_body
    object.body.truncate(7)
  end

  def files
    object.files.map { |file| Rails.application.routes.url_helpers.rails_blob_url(file) }
  end
end
