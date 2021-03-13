require 'rails_helper'

feature 'action heder', '
  when the user is logged in to: log out
  when a user is in a non-system in: login and: register
 ' do
   given(:user) { create(:user) }

   scenario 'the user is logged in' do

     sign_in(user)
     expect(page).to have_link 'Выход'
     expect(page).to_not have_link "Регистрация"
     expect(page).to_not have_link 'Вход'
   end

   scenario 'the user is out of the system' do
     visit root_path
     expect(page).to have_link "Регистрация"
     expect(page).to have_link 'Вход'
     expect(page).to_not have_link 'Выход'

   end
 end
