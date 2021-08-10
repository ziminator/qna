require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }
  let(:access_token) { create(:access_token) }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions/' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:user) { create :user }
      let!(:questions) { create_list(:question, 2, author: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, author: user, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_should_behave_like 'API ok status'

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'reterns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question, :with_files, :with_comments, :with_links)}
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:question_response) { json['question'] }
    let(:link) { question.links.first }
    let(:link_response) { question_response['links'].first }
    let(:comment) { question.comments.first }
    let(:comment_response) { question_response['comments'].first }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    it_should_behave_like 'API ok status'

    it 'returns all public fiels' do
      %w[id title body created_at updated_at].each do |attr|
        expect(question_response[attr]).to eq question.send(attr).as_json
      end
    end

    it 'returns all public fields with links' do
      %w[id name url linkable_type linkable_id created_at updated_at].each do |attr|
        expect(link_response[attr]).to eq link.send(attr).as_json
      end
    end

    it 'returns files url' do
      expect(question_response['files'].first).to match 'rails_helper.rb'
    end

    it 'returns all public fields with comments' do
      %w[id body commentable_type commentable_id created_at updated_at].each do |attr|
        expect(comment_response[attr]).to eq comment.send(attr).as_json
      end
    end
  end

  describe 'POST api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:headers) { { "ACCEPT" => "application/json" } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    describe 'create question' do
      context 'with valid attributed' do
        before { post api_path, params: { question: attributes_for(:question),
                                          access_token: access_token.token },
                                          headers: headers }

        it_should_behave_like 'API ok status'

        it 'saves new question into DB' do
          expect(Question.count).to eq 1
        end

        it 'returns fields of new question' do
          %w[id title body created_at updated_at].each do |attr|
            expect(json['question'].has_key?(attr)).to be_truthy
          end
        end
      end

      context 'with invalid attributes' do
        before { post api_path, params: { question: attributes_for(:question, :invalid),
                                          access_token: access_token.token },
                                          headers: headers }

        it 'returns unprocessable status' do
          expect(response).to be_unprocessable
        end

        it 'returns error for title' do
          expect(json.has_key?('title')).to be_truthy
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:headers) { { "ACCEPT" => 'application/json' } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :put }
    end

    describe 'author' do
      let(:author_access_token) { create(:access_token, resource_owner_id: question.author.id) }

      context 'update with valid attributes' do
        before { patch api_path, params: { access_token: author_access_token.token,
                                           question: { body: 'New body' } },
                                           headers: headers  }

        it_should_behave_like 'API ok status'

        it 'returns modified question fields ' do
          %w[id title body created_at updated_at files links comments].each do |attr|
            expect(json['question'].has_key?(attr)).to be_truthy
          end
        end

        it 'verifies that questions body was updated' do
          expect(json['question']['body']).to eq 'New body'
        end
      end

      context 'update with invalid attributes' do
        before { patch api_path, params: { access_token: author_access_token.token,
                                           question: { title: nil } },
                                           headers: headers  }

        it 'returns unprocessable status' do
          expect(response).to be_unprocessable
        end

        it 'returns error for title' do
          expect(json.has_key?('title')).to be_truthy
        end

        it 'verifies that questions body was not change' do
          question.reload
          expect(question.body).to eq 'MyText'
        end
      end

      context 'unable to edit another users question' do
        before { put api_path, params: { access_token: access_token.token,
                                         question: { body: 'Edit' } },
                                         headers: headers  }

        it 'returns forbidden status' do
          expect(response).to be_forbidden
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id/' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:headers) { { "ACCEPT" => 'application/json' } }
    let(:author_access_token) { create(:access_token, resource_owner_id: question.author.id) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it_behaves_like 'API resource deletable', Question
  end
end
