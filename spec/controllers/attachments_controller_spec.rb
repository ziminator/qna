require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: author) }

  describe 'DELETE #destroy by' do
    context 'user an author' do
      before do
        login(author)
      end

      it 'can delete question attachment' do
        add_file_to(question)

        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'can delete answer attachment' do
        add_file_to(answer)

        expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to change(answer.files, :count).by(-1)
      end
    end

    context 'user is not an author' do
      before do
        login(user)
      end

      it 'try to delete question attachment' do
        add_file_to(question)

        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
      end

      it 'try to delete answer attachment' do
        add_file_to(answer)

        expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to_not change(answer.files, :count)
      end
    end
  end

  describe 'DELETE #destroy by' do
    context 'guest' do

      it 'try to delete question and answer' do
        add_file_to(question)
        add_file_to(answer)

        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
        expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to_not change(answer.files, :count)
      end
    end
  end
end
