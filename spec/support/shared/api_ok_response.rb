shared_examples 'API ok status' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end
