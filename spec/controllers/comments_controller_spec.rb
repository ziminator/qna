require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, author: user }
  let(:create_comment) {
    post :create, params:
        { question_id: question.id, comment: attributes_for(:comment)
                                                  }, format: :json }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saved a new comment in the db' do
        expect { create_comment }.to change(Comment, :count).by 1
      end

      it 'user is author' do
        create_comment

        expect(assigns(:comment).author).to eq user
      end
    end

    context 'with invalid attributes' do
      it 'does not save the comment' do
        expect do
          post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question.id }, format: :json
        end.to_not change(Comment, :count)
      end
    end
  end
end
