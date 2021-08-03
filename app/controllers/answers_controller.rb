class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :answers_author!, only: %i[update destroy]

  include Voted

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    if @answer.save
      flash.now[:notice] = 'Your answer was successfully created.'
    end
  end

  def update
    @question = answer.question
    answer.update(answer_params)
    flash.now[:notice] = 'Your answer was successfully updated.'
  end

  def destroy
    @question = answer.question
    answer.destroy
    flash.now[:alert] = 'Answer was deleted.'
  end

  def select_best
    if current_user.author_of?(answer.question)
      answer.set_the_best
      @question = answer.question
    else
      head 403
    end
  end

  private

  def answers_author!
    head :forbidden unless current_user&.author_of?(answer)
  end

  def question
    @question ||= params[:question_id] ? Question.with_attached_files.find(params[:question_id]) : nil
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :question, :answer

  def answer_params
    params.require(:answer).permit(:body,
                                   files: [], links_attributes: [:name, :url])
  end
end
