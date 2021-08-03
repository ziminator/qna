class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comments-#{data['id']}"
  end
end
