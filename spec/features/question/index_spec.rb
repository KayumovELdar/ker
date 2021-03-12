require "rails_helper"

feature "просмотр всех вопросов", %q{
  Зайдя на основную страницу
  Можно просмотреть весь список вопросов
  } do

    given(:user){create(:user)}
    given!(:questions){create_list(:question, 5,user: user) }
    scenario 'проверка списка вопросов' do
      visit questions_path
      questions.each do |question|
        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end
    end
  end
