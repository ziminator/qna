RSpec.shared_examples 'votable' do
  let(:user) { create :user }
  let!(:user_2) { create :user }
  let!(:user_3) { create :user }
  let!(:user_4) { create :user }

  it '#method vote_up' do
    model.vote_up(user_2)
    model.reload

    expect(model.rating).to eq 1
  end

  it '#method vote_up as author' do
    model.vote_up(user)
    model.reload

    expect(model.rating).to eq 1
  end

  it '#method vote_down' do
    model.vote_down(user_2)
    model.reload

    expect(model.rating).to eq -1
  end

  it '#method vote_down as author' do
    model.vote_down(user)
    model.reload

    expect(model.rating).to eq -1
  end

  it '#method rating' do
    model.vote_up(user_2)
    model.vote_up(user_2)
    model.vote_down(user_2)
    model.vote_up(user_3)
    model.vote_up(user_4)
    model.reload

    expect(model.rating).to eq 2
  end
end
