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
  end

  scenario 'an unregistered user asks a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
