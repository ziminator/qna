class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :questions_author!, only: %i[update destroy]

  after_action :publish_question, only: %i[create]

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answers = question.answers.includes(:links).with_attached_files.order(best: :desc)
    @answer = question.answers.new
    @answer.links.new
    @comment = Comment.new

    gon.push question_id: question.id
    gon.push user_id: current_user&.id
  end

  def new
    question.links.build
    @award = question.build_award
  end

  def edit; end

  def create
    @question = Question.new(question_params)
    @question.author = current_user

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
    flash.now[:notice] = 'Question was updated.'
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: 'Question was deleted.'
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
        'questions',
        { question: question }
    )
  end

  def questions_author!
    head :forbidden unless current_user&.author_of?(question)
  end

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def answer
    @answer = question.answers.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [], links_attributes: %i[id name url _destroy],
                                     award_attributes: %i[name image])
  end
end
