class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: %i[create]

  authorize_resource

  def create
    @comment = commented_object.comments.new(body: comment_params[:comment_body])
    @comment.author = current_user
    if @comment.save
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def room_id
    commented_object.is_a?(Question) ? commented_object.id : commented_object.question.id
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
        "comments-#{room_id}", { comment: @comment }
    )
  end

  def comment_params
    params.require(:comment).permit(:comment_body)
  end

  def commented_object
    klass = [Question, Answer].detect { |c| params["#{c.name.underscore}_id"]}
    @commented_object = klass.find(params["#{klass.name.underscore}_id"])
  end
end
