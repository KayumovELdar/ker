require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
    # QUESTION:
    it { should be_able_to :create, Question }
    it { should be_able_to :update, create(:question, user: user) }
    it { should be_able_to :destroy, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question, user: other) }
    it { should_not be_able_to :destroy, create(:question, user: other) }
    # ANSWER:
    it { should be_able_to :create, Answer }
    it { should be_able_to :update, create(:answer, question: question, user: user) }
    it { should be_able_to :destroy, create(:answer, question: question, user: user) }
    it { should be_able_to :set_best, create(:answer, question: question, user: user) }
    it { should_not be_able_to :update, create(:answer, question: question, user: other) }
    it { should_not be_able_to :destroy, create(:answer, question: question, user: other) }
    # COMMENTS:
    it { should be_able_to :create, Comment }
    #LINKS:
    it { should be_able_to :destroy, create(:link, linkable: create(:question, user: user)) }
    it { should_not be_able_to :destroy, create(:link, linkable: create(:question, user: other)) }
    #VOTE
    it { should be_able_to %i[vote_for vote_against], other_question }
    it { should_not be_able_to %i[vote_for vote_against], question }
    it { should_not be_able_to :cancel_vote, question }
  end
end
