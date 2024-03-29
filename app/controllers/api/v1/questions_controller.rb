class Api::V1::QuestionsController < Api::V1::BaseController

  authorize_resource

  def index
    render json: questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: question
  end

  def create
    authorize! :create, Question

    question = Question.new(question_params)
    question.author = current_resource_owner

    if question.save
      render json: question, status: :created
    else
      render json: question.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, question

    if question.update(question_params)
      render json: question, status: :ok
    else
      render json: question.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, question

    question.destroy
  end

  private

  def questions
    @questions ||= Question.all
  end

  def question
    @question ||= Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
