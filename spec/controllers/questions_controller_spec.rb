require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question, author: user) }
  let(:user) { create(:user) }
  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, author: user) }

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

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns am answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new award to Question' do
      expect(assigns(:award)).to be_a_new(Award)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'parsings a new Link object for form' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: question } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to(assigns(:question))
      end

      it 'verifies if user is the author' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).author).to eq user
      end

    end
    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 'renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end
  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
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

      it 'renders update template' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do

      it 'does not change question' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end.to_not change(question, :title)
      end

      it 'renders update views' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js

        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user1) { create :user }
    let!(:question) { create :question, author: user1 }

    context 'User as an author' do
      before { login(user1) }

      it 'deletes gis question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end

    context 'User as not an author' do
      before { login(user) }

      it 'tries to delete a question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'return unauthenticated status' do
        delete :destroy, params: { id: question }

        expect(response).to have_http_status(403)
      end
    end

    context 'Unauthenticated user' do
      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to login' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to new_user_session_path
      end
    end

    it_behaves_like 'voted' do
      let(:user) { create :user }
      let(:model) { create :question, author: user }
    end
  end
end
