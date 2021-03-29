
require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question)}
  given(:gist_url1) {'https://gist.github.com/KayumovELdar/4e36eb9f97f59260c0f6d35e69ff6ea2'}
  given(:gist_url2) {'https://gist.github.com/KayumovELdar/a6c15d72980c611879f8bbb6dee93d09'}

  scenario 'User can add multiple links when give an answer ', js: true do
    sign_in(author)
    visit question_path(question)
    fill_in 'answer_body', with: 'My answer'

    fill_in 'Link name', with: "My gist1"
    fill_in 'Url', with: gist_url1

    click_on 'add link'

    within all(:css, ".nested-fields")[1] do
      fill_in 'Link name', with: "My gist2"
      fill_in 'Url', with: gist_url2
    end
    click_on 'Сохранить'

    within '.answers' do
      expect(page).to have_link 'My gist1', href: gist_url1
      expect(page).to have_link 'My gist2', href: gist_url2
    end
  end

end
