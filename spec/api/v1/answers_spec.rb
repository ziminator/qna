require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }
  let(:access_token) { create(:access_token) }
  let(:question)     { create(:question, :with_answers) }
  let(:answer)       { question.answers.first }

  describe 'GET /api/v1/questions/question_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token}, headers: headers }

      it_should_behave_like 'API ok status'

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:api_path)         { "/api/v1/answers/#{answer.id}" }
    let(:answer)           { create(:answer, :with_links, :with_files, :with_comments, question: question) }
    let(:answer_response)  { json['answer'] }
    let(:link)             { answer.links.first }
    let(:link_response)    { answer_response['links'].first }
    let(:comment)          { answer.comments.first }
    let(:comment_response) { answer_response['comments'].first }

    before { get api_path, params: { access_token: access_token.token }, headers: headers}

    it_should_behave_like 'API ok status'

    it 'returns all public fields' do
      %w[id body question_id created_at updated_at].each do |attr|
        expect(answer_response[attr]).to eq answer.send(attr).as_json
      end
    end

    it 'returns all public fields with links' do
      %w[id name url linkable_type linkable_id created_at updated_at].each do |attr|
        expect(link_response[attr]).to eq link.send(attr).as_json
      end
    end

    it 'returns files url' do
      expect(answer_response['files'].first).to match 'rails_helper.rb'
    end

    it 'returns all public fields for comments' do
      %w[id body created_at updated_at commentable_type commentable_id].each do |attr|
        expect(comment_response[attr]).to eq comment.send(attr).as_json
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers/' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:headers) { { "ACCEPT" => "application/json" } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'create question with valid attributes' do
      before { post api_path, params: { access_token: access_token.token,
                                        answer: { body: 'Body', question: question, author: question.author } },
                                        headers: headers  }

      it_should_behave_like 'API ok status'

      it 'saves new question into DB' do
        expect(Answer.count).to eq 1
      end

      it 'returns fields of new answer with valid attributes' do
        %w[id body created_at updated_at files links comments].each do |attr|
          expect(json['answer'].has_key?(attr)).to be_truthy
        end
      end
    end

    context 'create answer with invalid attributes' do
      before { post api_path, params: { access_token: access_token.token,
                                        answer: attributes_for(:answer, :invalid) },
                                        headers: headers  }
      it 'return status' do
        expect(response).to be_unprocessable
      end

      it 'returns error for body' do
        expect(json.has_key?('body')).to be_truthy
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let!(:answer) { create(:answer, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:headers) { { "ACCEPT" => 'application/json' } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :put }
    end
    describe 'Author' do
      let(:author_access_token) { create(:access_token, resource_owner_id: answer.author.id) }

      context 'update answer with valid attributes' do
        before { patch api_path, params: { access_token: author_access_token.token,
                                         answer: { body: 'New body' } },
                                         headers: headers  }

        it_should_behave_like 'API ok status'

        it 'returns fields of updated answer' do
          %w[id body created_at updated_at files links comments].each do |attr|
            expect(json['answer'].has_key?(attr)).to be_truthy
          end
        end

        it 'verifies that answer was updated' do
          expect(json['answer']['body']).to eq 'New body'
        end
      end

      context 'update answer with invalid attributes' do
        before { patch api_path, params: { access_token: author_access_token.token,
                                           answer: { body: nil } },
                                           headers: headers  }

        it 'returns unprocessable status' do
          expect(response).to be_unprocessable
        end

        it 'returns error for body' do
          expect(json.has_key?('body')).to be_truthy
        end

        it 'verefies that answers body was not changed' do
          answer.reload
          expect(answer.body).to eq 'MyTextAnswer'
        end
      end

      context 'unable edit other users answer' do
        before { patch api_path, params: { access_token: access_token.token,
                                         question: { body: 'Edit' } },
                                         headers: headers  }

        it 'returns forbidden status' do
          expect(response).to be_forbidden
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id/' do
    let!(:question) { create :question }
    let!(:answer) { create(:answer, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:headers) { { "ACCEPT" => 'application/json' } }
    let(:author_access_token) { create(:access_token, resource_owner_id: answer.author.id) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it_behaves_like 'API resource deletable', Answer
  end
end
