require 'rails_helper'

feature 'User can his answer', %q{
  In order to correct mistakes
  as an author of anser
  I'd like to be able to edit my answer
} do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }

  scenario 'Unauthenticated user can not edit answers' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do

    context 'edits his answer' do

      before do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'without errors' do
        click_on 'Обновить'

        within '.answers' do
          fill_in :answer_body, with: 'edited answer'
          click_on 'Сохранить'

          expect(page).to_not have_content answer.body
        end
      end

      scenario 'with errors' do
        click_on 'Обновить'

        within '.answers' do
          fill_in 'Ваш заголовок:', with: ''
          fill_in 'Ваш ответ:', with: ''
          click_on 'Сохранить'
        end
        expect(page).to have_content 'error(s)'
      end
    end

    scenario "tries to edit either user's answer" do
      sign_in(user)
      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end
  end
end
