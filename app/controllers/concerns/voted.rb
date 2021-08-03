module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_object, only: [:vote_up, :vote_down]
  end

  def vote_up
    make_vote(:vote_up)
  end

  def vote_down
    make_vote(:vote_down)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_object
    @object = model_klass.find(params[:id])
  end

  def make_vote(vote_method)
    return head :forbidden if current_user&.author_of?(@object)

    if @object.send(vote_method, current_user)

      render json: { resourceName: @object.class.name.downcase,
                     resourceId: @object.id,
                     resourceScore: @object.rating }
    else
      head :forbidden
    end
  end
end
