require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:author) { create(:user) }
  let!(:answer) { create(:answer, question: question, user: author) }
  let!(:question) { create(:question, user: author) }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(author) }

      it 'saves new answer in the database with assign user as author' do
        expect { post :create, params: { answer: attributes_for(:answer),
                 question_id: question } }.to change(question.answers, :count).by(1)
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
      before { login(author) }
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
        expect { post :create, params: { answer: attributes_for(:answer),
                 question_id: question } }.not_to change(user.answers, :count)
        expect(response).to redirect_to user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    describe 'Updates answer' do
      before { login(author) }

      context 'with valid attributes' do
        before { patch :update, params: { id: answer, answer: { body: "New body" }, question_id: question }, format: :js }
        it 'author changes answer attributes' do
          answer.reload
          expect(answer.body).to eq 'New body'
        end

        it 'renders :update back to question' do
          expect(response).to redirect_to answer.question
        end
      end

      context 'with invalid attributes'do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }

        it "doesn't changes answer attributes" do
          answer.reload
          expect(answer.body).to eq answer.body
        end

        it 're-render view' do
          expect(response).to render_template :show
        end
      end

      context 'non author' do
        before { login(user) }
        before { patch :update, params: { id: answer, answer: { body: "New body" }, question_id: question }, format: :js }

        it 'changes answer attributes' do
          answer.reload
          expect(answer.body).to_not eq 'New body'
        end

        it 'renders :update back to question' do
          expect(response).to redirect_to answer.question
        end
      end
    end

    describe 'Guest' do
      before { patch :update, params: { id: answer, answer: { body: "New body" }, question_id: question }, format: :js }

      context 'user try to update question' do
        it "does not changes question attributes" do
          answer.reload
          expect(answer.body).to_not eq "New body"
        end

        it 're-render edit' do
          expect(response).to redirect_to answer.question
        end
      end
    end
  end

  describe 'POST #best' do
    context 'Authenticated user as author' do
      before { login(author) }
      before { post :best, params: { id: answer }, format: :js }

      it 'select answer as best' do
        answer.reload
        expect(answer).to be_best
      end

      it 'render best template' do
        expect(response).to render_template :best
      end
    end

    context 'Authenticated user as user' do
      before { login(user) }
      before { post :best, params: { id: answer }, format: :js }

      it 'can not select answer as best' do
        answer.reload
        expect(answer).to_not be_best
      end

      it 'render best template' do
        expect(response).to render_template :best
      end
    end

    context 'Non authenticated user' do
      before { post :best, params: { id: answer }, format: :js }
      it 'can not select answer as best' do
        answer.reload
        expect(answer).to_not be_best
      end

      it 'render best template' do
        expect(response).to redirect_to user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'user an author' do
      before { login(author) }

      it 'delete the answer' do
         expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'user is not an author' do
      before { login(user) }

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
