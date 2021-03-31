require 'rails_helper'

feature 'User can add reward to question', %q{
  In order to to reward the user for the best answer
  as an quesiton's author
  I'd like to be able to add reward
} do
  given(:user) { create(:user) }
  given(:image_url)  {"https://s2.best-wallpaper.net/wallpaper/2560x1600/1212/Beautiful-nature-landscape-lake-mountains-trees-village-blue-sky-white-clouds_2560x1600.jpg"}

  scenario 'Author adds reward when asks a question' do
    sign_in(user)
    visit new_question_path

    within ".question" do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text'
    end

    within ".badge" do
      fill_in 'Badge title', with: "Best answer badge"
      fill_in 'Badge image url', with: image_url
    end

    click_on 'Ask'

    expect(page).to have_css("img[src*='#{image_url}']")
  end
end
