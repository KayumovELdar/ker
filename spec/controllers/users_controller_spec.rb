require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user)      {create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer)   { create(:answer, best: true, question: question, user: user) }
  let(:badge)   { create(:badge, question: question, user: user) }

  describe 'GET #badges' do
    let(:badges) { create_list(:badge, 3, question: question, user: user) }

    before do
      sign_in(user)
      get :badges, params: { id: user}
    end

    it "populates an array of user's badges" do
      expect(assigns(:badges)).to match_array(badges)
    end

    it 'renders badges view' do
      expect(response).to render_template :badges
    end
  end
end
