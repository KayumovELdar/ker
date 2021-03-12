require 'rails_helper'

feature 'user can see a question and answers to it', %q{
  for convenience
  as an unauthenticated user
  i'd like to see a question and answers together
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, question: question, user: user) }

  scenario 'unauthenticated user sees a question and answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.title
      expect(page).to have_content answer.body
    end
  end
end
