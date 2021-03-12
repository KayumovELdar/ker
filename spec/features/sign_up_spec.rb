require "rails_helper"

feature "Пользователь может зарегистрироваться", %q{
  Чтобы задавать вопросы
  Я хочу иметь возможность зарегистрироваться в систему
 } do

   background do
     visit root_path
     click_on 'Регистрация'
   end

   scenario "Не зарегестрированный пользователь пытается войти" do
     fill_in 'Email', with: "aaa@aaa.ru"
     fill_in 'Password', with: "123456"
     fill_in 'Password confirmation', with: "123456"
     click_on 'Sign up'
     expect(page).to have_content "Welcome! You have signed up successfully."

   end

   scenario "Ошибка не совпанения пороля" do
     fill_in 'Email', with: "aaa@aaa.ru"
     fill_in 'Password', with: "123456"
     click_on 'Sign up'
     expect(page).to have_content "Password confirmation doesn't match"

   end

   scenario "Ошибка не правильная почта" do
     fill_in 'Email', with: "aaa"
     fill_in 'Password', with: "123456"
     fill_in 'Password confirmation', with: "123456"
     click_on 'Sign up'
     expect(page).to have_content "Email is invalid"

   end

   scenario "Ошибка пустое поле" do
     click_on 'Sign up'
     expect(page).to have_content ("Email can't be blank" or "Password can't be blank")
   end

 end
