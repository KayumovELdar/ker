require 'rails_helper'

feature 'user can delete his questions', "
  for the sake of order
  as an authenticated user
  i'd like to be able to delete only my own questions
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'author deletes his question' do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Your question was successfully deleted!'
    expect(page).to_not have_content question.title
  end

  scenario "user tries to delete another's question" do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
