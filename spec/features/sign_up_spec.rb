require 'rails_helper'

feature 'The user can register', %q(
  To ask questions
  I want to be able to log in to the system
 ) do
   background do
     visit root_path
     click_on 'Регистрация'
   end

   scenario 'An unregistered user is trying to log in' do
     fill_in 'Email', with: 'aaa@aaa.ru'
     fill_in 'Password', with: '123456'
     fill_in 'Password confirmation', with: '123456'
     click_on 'Sign up'
     expect(page).to have_content 'Welcome! You have signed up successfully.'
   end

   scenario 'Password Mismatch Error' do
     fill_in 'Email', with: 'aaa@aaa.ru'
     fill_in 'Password', with: '123456'
     click_on 'Sign up'
     expect(page).to have_content "Password confirmation doesn't match"
   end

   scenario 'Error incorrect mail' do
     fill_in 'Email', with: 'aaa'
     fill_in 'Password', with: '123456'
     fill_in 'Password confirmation', with: '123456'
     click_on 'Sign up'
     expect(page).to have_content 'Email is invalid'
   end

   scenario 'Error empty field' do
     click_on 'Sign up'
     expect(page).to have_content("Email can't be blank")
   end
 end
