class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: :create
  before_action :find_answer, only: %i[edit update destroy best]
  before_action :check_authorship!, only: %i[update destroy best]

  def edit

  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer created sucessfully!'
    else
      render 'questions/show'
    end
  end

  def update
    if check_authorship!
      if @answer.update(answer_params)
        redirect_answer, notice: 'Your answer sucessfully updated.'
      else
        render 'questions/show'
      end
    else
      redirect_answer, notice: 'You are not an author of this question!'
    end
  end

  def destroy
    if check_authorship!
      @answer.destroy
      flash[:notice] = 'Your answer deleted sucessfully!'
    end
    redirect_answer
  end

  def best
    @answer.best! if current_user.author?(@answer.question)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def check_authorship!
    current_user.author?(@answer)
  end

  def redirect_answer
    redirect_to @answer.question
  end
end
