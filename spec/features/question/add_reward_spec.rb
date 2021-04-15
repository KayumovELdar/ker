require 'rails_helper'

feature 'User can add reward to question', %q{
  In order to to reward the user for the best answer
  as an quesiton's author
  I'd like to be able to add reward
} do
  given(:author) { create(:user) }

  scenario 'Author adds reward when asks a question' do
    sign_in(author)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text test question'

    fill_in 'Reward title', with: attributes_for(:reward)[:title]
    fill_in 'Reward image url', with: attributes_for(:reward)[:img_url]

    click_on 'Ask'
    save_and_open_page
  end
end
