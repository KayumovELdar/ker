require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'Author of question', js: true do

    background do
      sign_in author
      visit questions_path
    end

    scenario 'edits his question' do
      click_on 'Обновить'

      within '.questions' do

        fill_in 'Заголовок', with: 'заголовок вопроса'
        fill_in 'Содержание', with: 'содержание вопроса'
        click_on 'Сохранить'

        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
        click_on 'Обновить'

      within '.questions' do

        fill_in 'Заголовок', with: ''
        fill_in 'Содержание', with: ''
        click_on 'Сохранить'

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'edits his question whitn attached files' do
      expect(page).to_not have_link 'rails_helper.rb'
      expect(page).to_not have_link 'spec_helper.rb'

      within '.questions' do
        click_on 'Обновить'
        attach_file 'File',["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Сохранить'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

  end

  scenario "Authenticated user tries to edit other user's question", js: true do
    sign_in user
    visit questions_path

    expect(page).to_not have_link 'Обновить'
  end

  scenario 'Unauthenticated user can not edit answer' do
    visit questions_path

    expect(page).to_not have_link 'Обновить'
  end
end
