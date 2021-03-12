require "rails_helper"

feature "просмотр всех вопросов", %q{
  Зайдя на основную страницу
  Можно просмотреть весь список вопросов
  } do
    #создание массива вопросов
    given!(:questions){create_list(:question, 5) }
    #проверка созданных вопросов
    scenario 'проверка списка вопросов' do
      #зайти на страницу с списком вопросов
      visit questions_path
      save_and_open_page
      #проверка по списку соответствий
      questions.count.times do |n|
        expect(page).to have_content "Заголовок вопроса № #{n+1}."
      end
    end
  end
