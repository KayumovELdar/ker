require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should_not allow_value('sddsfdssfddslmfsd;lkmdsf').for :url }
  it { should allow_value('https://github.com').for :url }

  describe 'gist_url' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    let!(:link1) { create(:link, name: "gist_url",
                                    url: "https://gist.github.com/kpkodil/2fab8b5c571ba048b67d3b8dc1ca7b1f",
                                    linkable: question) }
    let!(:link2) { create(:link, name: "youtube_url",
                                    url: "https://www.youtube.com/",
                                    linkable: question) }

    it 'is a gist when the url is linked to gist' do
      expect(link1.gist_url?).to be_truthy
    end

    it 'is not a gist when the url is not linked to gist' do
      expect(link2.gist_url?).to be_falsey
    end
  end
end
