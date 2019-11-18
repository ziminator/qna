require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:author) { create(:user) }
  let!(:not_author) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'Authenticated user' do
      before { login(user) }
      before { get :new }

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'render new view' do
        expect(response).to render_template :new
      end
    end

    context 'Not authenticated user' do
      it 'render new view' do
        expect(response).to_not render_template :new
      end
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do

    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new question in the database' do
        count = Question.count

        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end

    context 'guests' do
      it 'can not create question' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
        expect(response).to redirect_to user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    let!(:not_author) { create(:user) }
    let!(:question) { create(:question, user: not_author) }

    context 'with valid attributes' do
      before { login(user) }

      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 're-renders edit view' do
        expect(response).to render_template :show
      end
    end

    context 'user is not an author' do
      before { login(not_author) }

      it 'can not update the question' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
        expect(response).to redirect_to question
      end
    end

    context 'guests' do
      it 'can not update the question' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload

        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'

        expect(response).to redirect_to user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: author) }

    context 'author can delete the question' do
      before { login(author) }

      it 'delete the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to #index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'non-author can not delete the question' do
      before { login(user) }

      it 'can not delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to questions' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'guests' do
      it 'can not delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        expect(response).to redirect_to user_session_path
      end
    end
  end
end
