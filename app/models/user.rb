class User < ApplicationRecord
  has_many :questions
  has_many :answers

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author?(author)
    author.user_id == id
  end
end
