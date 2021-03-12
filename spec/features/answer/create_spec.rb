require "rails_helper"

feature "Пользователь может создать ответ на любой вопрос", %q{
  Чтобы дать ответ сообществу
  Как аутентифицированный Пользователь
  Я хотел бы иметь возможность задать ответ
  } do
    given(:user) {create(:user) }
    given(:question) { create(:question, user:user)}

    describe 'Авторизованный пользователь' do
      before do
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
