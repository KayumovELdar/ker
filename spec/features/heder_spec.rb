require 'rails_helper'

feature 'шапка для действий', '
  когда в системе в шапке вход
  когда в не системы в шапке вход и регистрация
 ' do
   given(:user) { create(:user) }

   scenario 'пользователь зашел в систему' do

     sign_in(user)
     expect(page).to have_link 'Выход'
     expect(page).to_not have_link "Регистрация"
     expect(page).to_not have_link 'Вход'
   end

   scenario 'пользователь вне системы' do
     visit root_path
     expect(page).to have_link "Регистрация"
     expect(page).to have_link 'Вход'
     expect(page).to_not have_link 'Выход'

   end
 end
