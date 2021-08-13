class User < ApplicationRecord

  TEMP_EMAIL_REGEX = /@change.me/.freeze

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github vkontakte instagram]

  has_many :answers, foreign_key: 'author_id', dependent: :destroy
  has_many :questions, foreign_key: 'author_id', dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :awards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_questions, through: :subscriptions, source: :question

  validates :email, format: { without: TEMP_EMAIL_REGEX }, on: :update

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def author_of?(object)
    object.author_id == id
  end

  def email_verified?
    !email.match(TEMP_EMAIL_REGEX)
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def subscribed_to_question?(question)
    subscribed_questions.exists?(question.id)
  end
end
