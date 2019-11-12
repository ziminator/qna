require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let!(:not_author) { create (:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: author) }

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

  describe 'PATCH #update' do
    describe 'author updates answer' do
      before { login(author) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: "New body" }, question_id: question }, format: :js
        answer.reload
        expect(answer.body).to eq 'New body'
      end

      it 'renders :update back to question' do
          patch :update, params: { id: answer, answer: { body: "New body" }, question_id: question }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes'do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }

        it "doesn't changes answer attributes" do
          answer.reload
          expect(answer.body).to eq "MyText"
        end

        it 'renders :update' do
          expect(response).to render_template :update
        end
      end
    end

    describe 'Non-author user updates question' do
      before { login(user) }
      before { patch :update, params: { id: answer, answer: { body: "New body" }, question_id: question }, format: :js }

      it "does not changes question attributes" do
        question.reload

        expect(question.body).to_not eq "New body"
      end

      it 're-render edit' do
        expect(response).to redirect_to answer.question

      end
    end
  end

  describe 'PATCH #best' do
    describe 'Non authenticated user' do
      before { patch :best, params: { id: answer, answer: { best: true }, question_id: question }, format: :js }

      scenario 'pick best answer' do
        answer.reload

        expect(answer).to_not be_best
      end
    end

    describe 'Authenticated user (non-author)' do
      before do
        sign_in(user)
        patch :best, params: { id: answer, answer: { best: true }, question_id: question }, format: :js
      end

      scenario 'pick best answer' do
        answer.reload

        expect(answer).to_not be_best
      end

      scenario 're-renders question' do
        expect(response).to redirect_to answer.question
      end
    end

    scenario 'Authenticated author pick best answer' do
      sign_in(author)

      patch :best, params: { id: answer, answer: { best: true }, question_id: question }, format: :js
      answer.reload

      expect(answer).to be_best
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
      before { login(not_author) }

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
