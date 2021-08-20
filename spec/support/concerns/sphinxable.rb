require 'rails_helper'

RSpec.shared_examples 'sphinxable' do |target|

  it 'should ThinkingSphinx::Search' do
    expect(target.search).to be_kind_of(ThinkingSphinx::Search)
  end
end
