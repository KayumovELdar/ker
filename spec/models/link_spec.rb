require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should_not allow_value('sddsfdssfddslmfsd;lkmdsf').for :url }
  it { should allow_value('https://github.com').for :url }


  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  describe 'gist_url?' do

    let!(:link1) { create(:link, name: "A gist",
                                  url: "https://gist.github.com/KayumovELdar/4e36eb9f97f59260c0f6d35e69ff6ea2",
                                  linkable: question) }
    let!(:link2) { create(:link, name: "Not a gist",
                                  url: "https://blahblahblah.foo",
                                  linkable: question) }

    it 'is a gist when the url is linked to gist' do
      expect(link1.gist_url?).to be_truthy
    end

    it 'is not a gist when the url is not linked to gist' do
      expect(link2.gist_url?).to be_falsey
    end
  end
end
