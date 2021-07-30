require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:url) { 'https://gist.github.com/ziminator/8d3a2583c4b3dad144acbd9d293ad96f' }
  let!(:gist) { Link.new(name: 'gist', url: url, linkable: question) }
  let!(:invalid_gist) { Link.new(name: 'non gist', url: 'https://thinknetica.com', linkable: question) }

  describe '#gist? method' do
    it 'justifies that link contents gist' do
      expect(gist).to be_gist
    end
  end

  describe '#gist_body method' do
    it 'verifies that link is a gist' do
      expect(gist.gist_body).to eq 'hello_world.txt'
    end

    it 'verifies that link is not a gist' do
      expect(invalid_gist).to_not be_gist
    end
  end
end
