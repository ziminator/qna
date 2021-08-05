require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer into database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question },format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: {  question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end

      it 'verifies if user is the author' do
        post :create, params: {  question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer).author).to eq user
      end
    end

    context 'with ivalid attributes' do
      it 'does not save answer into database' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 're-renders create' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'with valid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :edit_body) }, format: :js }

      it 'changes answer attributes' do
        answer.reload

        expect(answer.body).to eq 'New body'
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 're-renders update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user1) { create :user }
    let!(:answer) { create :answer, question: question, author: user1 }

    context 'Author of the question' do
      before { login(user1) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(question.answers, :count).by(-1)
      end

      it 'expects response to have 200 status' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to have_http_status(200)
      end
    end

    context 'Not an author' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'expects response to have 403 status' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to have_http_status(403)
      end
    end

    context 'Unauthenticated user' do
      it 'tries to delete an answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to login' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #select_best' do
    context 'Author of the question' do
      before { login(user) }

      it 'tries to select one best answer' do
        post :select_best, params: { id: answer, format: :js }
        answer.reload
        expect(answer.best).to be true
      end

      it 'renders ranked answers' do
        post :select_best, params: { id: answer, format: :js }
        expect(response).to render_template :select_best
      end
    end

    context 'not an author of the question' do
      let(:other_user) { create(:user) }
      before { login(other_user) }

      it 'tries to select the best answer' do
        post :select_best, params: { id: answer, format: :js }
        answer.reload
        expect(answer.best).to be false
      end

      it 'renders answers' do
        post :select_best, params: { id: answer, format: :js }
        expect(response).to have_http_status(403)
      end
    end

    it_behaves_like 'voted' do
      let(:model) { create :answer, question: question, author: user }
    end
  end
end
