require "rails_helper"

feature "Пользователь может создать вопросс", %q{
  Чтобы получить ответ от сообщества
  Как аутентифицированный Пользователь
  Я хотел бы иметь возможность задать вопрос
  } do

   given(:user) {create(:user) }

  describe 'Авторизованный пользователь' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario " задает вопрос" do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario ' задает вопрос с ошибкой' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario "незарегестрированный пользователь задает вопрос" do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'

  end
 end
