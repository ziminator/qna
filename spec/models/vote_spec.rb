require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }

  it { should validate_presence_of :score }
  it { should validate_inclusion_of(:score).in_array([1, -1]) }
end
