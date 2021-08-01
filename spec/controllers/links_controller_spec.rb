require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  let(:user) { create :user }
  let!(:question) { create :question , author: user }
  let!(:link) { create :link, linkable: question }

  describe "DELETE #destroy" do
    context 'Author' do
      before { login(user) }

      it 'deletes attached links' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
      end

      it 'returns response with status :ok' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to have_http_status :ok
      end
    end

    context 'Other user' do
      let(:other_user) { create :user }

      before { login(other_user) }

      it 'tries to delete attached link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(Link, :count)
      end

      it 'returns response with status :forbidden' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to have_http_status :forbidden
      end
    end

    context 'Unauthenticated user' do

      it 'tries to delete attached links' do
        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(Link, :count)
      end

      it 'returns response with status :unauthorized' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
