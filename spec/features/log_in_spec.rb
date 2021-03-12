require "rails_helper"

feature "The user can log out of the account", %q{
  To change your account
  I want to be able to log out
 } do

   given(:user) {create(:user) }
   background do
     sign_in(user)
   end
   scenario "An unregistered user is trying to log in" do
     click_on 'Выход'
     expect(page).to have_content "Signed out successfully."
   end
 end
