shared_examples 'API resource deletable' do |target|
  context 'unable destroy another users question' do
    let(:action1) { delete api_path, params: { access_token: access_token.token }, headers: headers  }

    it 'destroys other users resource' do
      expect { action1 }.to_not change(target, :count)
    end

    it 'returns :forbidden status' do
      action1

      expect(response).to be_forbidden
    end
  end

  context 'destroys own resource' do
    let(:action2) { delete api_path, params: { access_token: author_access_token.token }, headers: headers  }

    it 'destroys resource' do
      expect { action2 }.to change(target, :count).by(-1)
    end

    it 'returns :ok status' do
      action2

      expect(response).to be_successful
    end
  end
end
