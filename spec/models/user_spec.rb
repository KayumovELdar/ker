require 'rails_helper'

RSpec.describe User, type: :model do

  it { should have_many(:rewards) }
  it { should have_many(:reward_ownings) }
  it { should have_many(:rewards).through(:reward_ownings) }
  it { should have_many(:answers) }
  it { should have_many(:questions) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: author) }

  it 'user is author' do
    expect(author).to be_author(question)
  end

  it 'user is not author' do
    expect(user).not_to be_author(question)
  end
end
