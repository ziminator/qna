require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do

        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answer, :count).by(1)
      end

#      it 'redirects to answer show view' do
#        post :create, params: { answer: attributes_for(:answer), question_id: question }
#        expect(response).to redirect_to assigns(:question)
#      end

#      it 'check assign a new answer to question' do
#        post :create, params: { answer: attributes_for(:answer), question_id: question }
#        expect(assigns(:answer).question).to eq question
#      end
#    end

#    context 'answer with invalid attributes' do
#      it 'does not save the answer' do
#        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(question.answers, :count)
#      end

#      it 'answer re-render new view' do
#        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
#        expect(response).to render_template 'question/show'
#      end
    end
  end

=begin
  describe 'GET #edit' do
    before { get :edit, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(responce).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do

      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer attributes' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new body' } }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to update question' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer, :invalid_answer) }
      end

      it 'does not change question' do
        answer.reload
        expect(answer.body).to eq 'MyText'
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:author) { create(:user) }
    let!(:author_answer) { create(:answer, question: question, user: author) }

    context 'user an author' do
      before { login(author) }

      it 'delete the answer' do
        expect { delete :destroy, params: { id: author_answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to question show' do
        delete :destroy, params: { id: author_answer }
        expect(response).to redirect_to question
      end
    end

    context 'user is not an author' do
      before { login(user) }

      it 'delete the question' do
        expect { delete :destroy, params: { id: author_answer } }.to_not change(Answer, :count)
      end

      it 'redirects to question show' do
        delete :destroy, params: { id: author_answer }
        expect(response).to redirect_to author_answer.question
      end
    end
  end
=end
end
