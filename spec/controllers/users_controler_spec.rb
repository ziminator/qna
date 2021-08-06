require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #finish_sign_up' do
    context 'user proceed registration' do
      let(:user) { create(:user, email: 'mail@change.me') }

      it 'renders finish_sign_up template' do
        get :finish_sign_up, params: { id: user }

        expect(response).to render_template :finish_sign_up
      end

      it 're-renders finish_sign_up template without new email' do
        patch :finish_sign_up, params: { id: user }

        expect(response).to render_template :finish_sign_up
      end

      it 'confirms new email' do
        patch :finish_sign_up, params: { id: user, user: { email: 'new@mail.ru' } }
        sleep 1
        user.reload
        user.confirm

        expect(user.email).to eq 'new@mail.ru'
      end
    end

    context 'user exists' do
      let(:user) { create(:user) }
      it 'redirect to root_path' do
        login(user)
        get :finish_sign_up, params: { id: user }

        expect(response).to redirect_to root_path
      end
    end
  end
end
