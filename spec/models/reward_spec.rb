require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to(:question) }
  it { should have_one(:reward_owning) }
  it { should have_one(:user).through(:reward_owning) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:img_url) }

end
