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
      sign_in (author)
      visit questions_path
    end

    scenario 'edits his question' do

      within '.questions' do
        click_on 'Edit'
        #save_and_open_page
        fill_in :question_title, with: 'заголовок вопроса'
        fill_in :question_body, with: 'содержание вопроса'
        click_on 'Save'

        expect(page).to have_content question.body
        expect(page).to have_content question.title
      end
    end

    scenario 'edits his question with errors' do

      within '.questions' do
        click_on 'Edit'
        fill_in :question_title, with: ''
        fill_in :question_body, with: ''
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end
    scenario 'edits his question whitn attached files' do
      click_on 'Edit'

      within '.questions' do
        attach_file 'File',["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end
      click_on question.title

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end


  end

  scenario "Authenticated user tries to edit other user's question", js: true do
    sign_in user
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  scenario 'Unauthenticated user can not edit answer' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end
end
