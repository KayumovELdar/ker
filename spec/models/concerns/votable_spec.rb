require 'rails_helper'

shared_examples_for "votable" do
  it { should have_many(:votes).dependent(:destroy) }

  let(:votable) { create(described_class.to_s.underscore.to_sym) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  it '#up' do
    votable.up(user1)
    expect(Vote.last.value).to eq 1
    expect(Vote.last.user).to eq user1
    expect(Vote.last.votable).to eq votable
  end

  it 'tries to vote up twice' do
    votable.up(user1)
    votable.up(user1)
    votable.down(user1)
    expect(votable.rating).to eq 1
  end

  it '#down' do
    votable.down(user1)
    expect(Vote.last.value).to eq -1
    expect(Vote.last.user).to eq user1
    expect(Vote.last.votable).to eq votable
  end

  it 'tries to vote down twice' do
    votable.down(user1)
    votable.down(user1)
    expect(votable.rating).to eq -1
  end


  it '#rating' do
    votable.up(user1)
    votable.down(user1)
    votable.up(user2)
    expect(votable.rating).to eq 2
  end
end
