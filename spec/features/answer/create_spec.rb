require "rails_helper"

feature "The user can create an answer to any question", %q{
  To give a response to the community
  As an authenticated User
  I would like to be able to ask the answer
  } do
    given(:user) {create(:user) }
    given(:question) { create(:question, user:user)}

    describe 'Авторизованный пользователь' do
      background do
        sign_in(user)
        visit question_path(question)
      end
      scenario "дает ответ на вопрос" do
        fill_in "Заголовок", with: "Ответ_1"
        fill_in "Текст ответа", with: 'text text text'
        click_on "Завершить"

        expect(page).to have_content 'Ответ сохранен.'
        expect(page).to have_content "Ответ_1"
        expect(page).to have_content 'text text text'

      end
      scenario "дает ответ с ошибкой" do
        fill_in "Заголовок", with: ""
        fill_in "Текст ответа", with: 'text text text'
        click_on "Завершить"

        expect(page).to have_content 'error(s)'
      end
    end
    scenario " не авторизованный пользователь хочет дать ответ" do
      visit question_path(question)
      fill_in "Заголовок", with: "Ответ_1"
      fill_in "Текст ответа", with: 'text text text'
      click_on "Завершить"

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
