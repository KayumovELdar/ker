require "rails_helper"

feature "The user can log in", %q{
  To ask questions
  As an unregistered User
  I want to be able to log in
 } do

   given(:user) {create(:user) }
   background do
     visit root_path
     click_on 'Вход'
   end

   scenario "the user is already in the system, he wants to log in" do
     fill_in 'Email', with: user.email
     fill_in 'Password', with: user.password
     click_on 'Log in'
     expect(page).to have_content 'Signed in successfully.'

   end

   scenario "he user is not in the system, he wants to log in" do
     fill_in 'Email', with: 'wrong@test.ru'
     fill_in 'Password', with: '123456'
     click_on 'Log in'

     expect(page).to have_content 'Invalid Email or password.'
   end

 end
