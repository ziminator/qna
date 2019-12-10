class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show edit update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers
    @answer = Answer.new
  end

  def new
    @question = current_user.questions.new
    @question.links.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if check_authorship!
      @question.update(question_params)
      redirect_question
    else
      render :show
    end
  end

  def destroy
    if check_authorship!
      @question.destroy
      flash[:notice] = 'Your question deleted sucessfully.'
    end
    redirect_question
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                    files: [], links_attributes: [:name, :url] )
  end

  def check_authorship!
    current_user.author?(@question)
  end

  def redirect_question
    redirect_to @question
  end
end
