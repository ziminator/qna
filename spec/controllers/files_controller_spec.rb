require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:user) { create :user }
  let!(:question) do
    create :question,
           author: user,
           files: fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")
  end
  let!(:question_file) { question.files.first }

  describe 'DELETE #destroy' do
    context 'User is author' do
      before { login(user) }

      it 'deletes the file' do
        expect { delete :destroy, params: { id: question_file }, format: :js }.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'reterns response with status 200' do
        delete :destroy, params: { id: question_file }, format: :js

        expect(response).to have_http_status(200)
      end
    end

    context 'User in not the author' do
      let(:user1) { create :user }

      before { login(user1) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: question_file }, format: :js }.to_not change(ActiveStorage::Attachment, :count)
      end

      it 'reterns response with 403 status' do
        delete :destroy, params: { id: question_file }, format: :js

        expect(response).to have_http_status(403)
      end
    end

    context 'Unauthenticated user' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: question_file }, format: :js }.to_not change(ActiveStorage::Attachment, :count)
      end

      it 'reterns response with 401 status' do
        delete :destroy, params: { id: question_file }, format: :js

        expect(response).to have_http_status(401)
      end
    end
  end
end
