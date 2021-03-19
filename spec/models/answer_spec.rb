require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe 'check set_best method' do
    let(:user) { create(:user) }
    let(:question1) { create(:question, user: user) }
    let(:question2) { create(:question, user: user) }
    let!(:answer1) { create(:answer, question: question1, user: user) }
    let!(:answer2) { create(:answer, question: question1, user: user) }
    let!(:answer3) { create(:answer, question: question2, user: user) }

    it 'select answer as best' do
      answer1.set_best
      expect(answer1).to be_best
    end

    it 'only one answer may be best' do
      answer1.set_best
      answer2.set_best
      expect(question1.answers.where(best: :true).count).to eq 1
    end

    it 'the best answers are not related' do
      answer1.set_best
      answer3.set_best
      expect(Answer.where(best: :true).count).to eq 2
    end
  end
end
