require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create :user }
    let(:question) { create :question }

    it 'returns 401 when user does not logged in' do
      post :create, params: { question_id: question.id }, format: :js

      expect(response.status).to eq 401
    end

    context 'Login user' do
      before { login user }

      it 'returns 200' do
        post :create, params: { question_id: question.id }, format: :js

        expect(response.status).to eq 200
      end

      it 'saves subscription into db' do
        expect do
          post :create, params: { question_id: question.id }, format: :js
        end.to change(Subscription, :count).by 2
      end

      it 'renders template' do
        post :create, params: { question_id: question.id }, format: :js

        expect(response).to render_template :create
      end
    end
  end

  describe 'POST #destroy' do
    let(:user) { create :user }
    let(:question) { create :question }
    let!(:subscription) { create :subscription, user: user, question: question }

    it 'return 403 when user does not logged in' do
      delete :destroy, params: { id: subscription }, format: :js

      expect(response.status).to eq 401
    end

    context 'Login user' do
      before { login user }

      it 'deletes subscription from db' do
        expect do
          delete :destroy, params: { id: subscription }, format: :js
        end.to change(Subscription, :count).by(-1)
      end

      it 'renders template' do
        delete :destroy, params: { id: subscription }, format: :js

        expect(response).to render_template :destroy
      end
    end
  end
end
