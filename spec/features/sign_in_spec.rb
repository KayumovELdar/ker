require "rails_helper"

feature "Пользователь может залогиниться", %q{
  Чтобы задавать впросы
  Как не зарегестрированный Пользователь
  Я хочу иметь возможность войти в систему
 } do

   given(:user) {User.create!(email: 'user@test.ru', password: '123456') }
   background { visit new_user_session_path }

   scenario "пользователь уже есть в системе, он хочет войти" do
     fill_in 'Email', with: user.email
     fill_in 'Password', with: user.password
     click_on 'Log in'
     expect(page).to have_content 'Signed in successfully.'

   end

   scenario "пользователя нет в системе, он хочет войти" do
     fill_in 'Email', with: 'wrong@test.ru'
     fill_in 'Password', with: '123456'
     click_on 'Log in'

     expect(page).to have_content 'Invalid Email or password.'
   end

 end
