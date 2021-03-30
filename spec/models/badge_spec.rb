require 'rails_helper'

RSpec.describe Badge, type: :model do
  it { should belong_to :question }}
  it { should have_one :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :image_url }

  let!(:user) {create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:badge) { create(:badge, question: question) }

  describe '#badge_the_user' do

    it 'badge the user for the best answer' do
      badge.badge_the_user(user)

      expect(user.badge.first).to eq badge
    end
  end
end
