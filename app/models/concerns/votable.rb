module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    votes.sum(:score)
  end

  def vote_up(user)
    if user_votes(user)&.score == -1
      user_votes(user).destroy
    elsif !user_votes(user)
      votes.create(user: user, score: 1)
    end
  end

  def vote_down(user)
    if user_votes(user)&.score == 1
      user_votes(user).destroy
    elsif !user_votes(user)
      votes.create(user: user, score: -1)
    end
  end

  private

  def user_votes(user)
    votes.find_by(user_id: user.id)
  end
end
