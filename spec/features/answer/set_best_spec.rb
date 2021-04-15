require 'rails_helper'

feature 'Set best answer', %q{
  In order to choose answer that is the best
  As an authenticated user
  I want to be able to set best answer for my question
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:answers) { create_list(:answer, 2, question: question, user: author) }

  describe 'Author of question', js: true do

    background do
      sign_in author
      visit question_path(answer.question)
    end
  end

  scenario "User tries to set best answer of other user's question", js: true do
    sign_in user
    visit question_path(answer.question)

    expect(page).to_not have_link 'Выбрать лучшее'
  end

  scenario "Unauthenticated user tries to set best answer" do
    visit question_path(answer.question)

    expect(page).to_not have_link 'Выбрать лучшее'
  end
end
