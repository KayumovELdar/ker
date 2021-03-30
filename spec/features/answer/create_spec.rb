require 'rails_helper'

feature 'The user can create an answer to any question', '
  To give a response to the community
  As an authenticated User
  I would like to be able to ask the answer
  ' do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }

    describe 'Authorized User', js: true do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'gives an answer to the question' do

        fill_in 'Заголовок', with: 'Ответ_1'
        fill_in 'Текст ответа', with: 'text text text'
        click_on 'Завершить'

        expect(current_path).to eq question_path(question)
        within '.answers' do
          expect(page).to have_content 'Ответ_1'
          expect(page).to have_content 'text text text'
        end
      end

      scenario 'returns an error response' do
        fill_in 'Заголовок', with: ''
        fill_in 'Текст ответа', with: 'text text text'
        click_on 'Завершить'

        expect(page).to have_content 'error(s)'
      end

      scenario ' gives an answer with attached file' do
        fill_in 'Заголовок', with: 'Ответ_1'
        fill_in 'Текст ответа', with: 'text text text'

        attach_file 'File',["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Завершить'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

    end

    scenario ' an unauthorized user wants to give an answer' do
      visit question_path(question)
      fill_in 'Заголовок', with: 'Ответ_1'
      fill_in 'Текст ответа', with: 'text text text'
      click_on 'Завершить'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
