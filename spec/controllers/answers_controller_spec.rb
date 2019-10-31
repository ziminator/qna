require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user) }
      it 'saves new answer in the database with assign user as author' do
        expect { post :create, params: { answer: attributes_for(:answer),
                 question_id: question } }.to change(user.answers, :count).by(1)
      end

      it 'saves the association to question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(assigns(:answer).question).to eq question
      end

      it 'redirects to question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { login(user) }
      it "doesn't save a new answer in database" do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count)
      end

      it 're-render question' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end

    context 'guest cannot make answers' do
      it 'redirect to user sign in' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect { post :create, params: { answer: attributes_for(:answer),
                 question_id: question } }.not_to change(user.answers, :count)
        expect(response).to redirect_to user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'user an author' do
      before { login(user) }

      it 'delete the answer' do
         expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'user is not an author' do
      let!(:not_author) { create (:user) }

      before { login(not_author) }
      before { answer }

      it 'delete answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'guests' do
      it 'can not delete answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
        expect(response).to redirect_to user_session_path
      end
    end
  end
end
