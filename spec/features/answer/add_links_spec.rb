
require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question)}
  given(:url1) {'youtube_url'}
  given(:url2) {'https://www.yandex.ru'}

  scenario 'User can add multiple links when give an answer ', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'answer_body', with: 'My answer'

    fill_in 'Link name', with: "My gist1"
    fill_in 'Url', with: url1

    click_on 'add link'

    within all(:css, ".nested-fields")[1] do
      fill_in 'Link name', with: "My gist2"
      fill_in 'Url', with: url2
    end
    click_on 'Сохранить'

    within '.answers' do
      expect(page).to have_link 'My gist1', href: url1
      expect(page).to have_link 'My gist2', href: url2
    end
  end

end
