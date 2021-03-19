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

    scenario 'set best answer' do
      within "div#answer_#{answer.id}" do
        expect(page).not_to have_content 'Лучший ответ'
        click_on 'Выбрать лучшее'
        expect(page).to have_content 'Лучший ответ'
      end
    end

    scenario 'set new answer as best' do

      within "div#answer_#{answers[-1].id}" do
        click_on 'Выбрать лучшее'
      end

      within "div#answer_#{answers[0].id}" do
        click_on 'Выбрать лучшее'
        expect(page).to_not have_content 'Выбрать лучшее'
      end

      answers[1, answers.size].each do |answer|
        within "div#answer_#{answer.id}" do
          expect(page).to have_content 'Выбрать лучшее'
        end
      end

      expect(page.find('.answers div:first-child')).to have_content answers[0].body
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
