require "rails_helper"

feature "Пользователь может выйти из учетной записи", %q{
  Чтобы менить учетную запись
  Я хочу иметь возможность выйти из системы
 } do

   given(:user) {create(:user) }
   background do
     sign_in(user)
   end
   scenario "Не зарегестрированный пользователь пытается войти" do
     click_on 'Выход'
     expect(page).to have_content "Signed out successfully."
   end
 end
