require 'rails_helper'

feature 'The user can create a question', '
  To get a response from the community
  As an authenticated User
  I would like to be able to ask a question
  ' do
  given(:user) { create(:user) }

  describe 'Authorized User' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario ' asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario ' asks a question with an error' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario ' asks a question with attached file' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      attach_file 'File',["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

  end

  describe 'multiple sessions', js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)

        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'

        fill_in 'Заголовок', with: 'qTitle'
        fill_in 'Содержание', with: 'qBody'
        click_on 'Сохранить'
        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'qTitle'
        expect(page).to have_content 'qBody'
      end

      Capybara.using_session('guest') do
        expect(page).to have_link 'qTitle'
      end
    end
  end



  scenario 'an unregistered user asks a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
