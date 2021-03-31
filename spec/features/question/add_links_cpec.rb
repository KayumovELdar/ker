require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:url1) {'https://www.yandex.ru'}
  given(:url2) {'https://www.youtube.com'}

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Link name', with: "My gist1"
    fill_in 'Url', with: url1

    click_on 'add link'

    within all(:css, ".nested-fields")[1] do
      fill_in 'Link name', with: "My gist2"
      fill_in 'Url', with: url2
    end
    click_on 'Ask'

    expect(page).to have_link 'My gist1', href: url1
    expect(page).to have_link 'My gist2', href: url2
  end

end
