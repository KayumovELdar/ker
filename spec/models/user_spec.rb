require 'rails_helper'

RSpec.describe User, type: :model do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:answer) { create(:answer,question: question, user: author) }

  it { should have_many(:answers) }
  it { should have_many(:questions) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'user is author' do
    expect(author.author?(question)).to be_truthy
    expect(author.author?(answer)).to be_truthy
  end

  it 'user is not author' do
    question = create(:question)
    expect(user.author?(question)).to be_falsy
    expect(user.author?(answer)).to be_falsy
  end


end
