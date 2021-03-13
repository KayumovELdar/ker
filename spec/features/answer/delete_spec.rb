require 'rails_helper'

feature 'user can delete his answer', "
  for the sake of order
  as an authenticated user
  i'd like to be able to delete only my own answers
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }

  scenario 'author deletes his answer' do
    sign_in(answer.user)
    visit question_path answer.question
    click_on 'Delete answer'

    expect(page).to have_content 'Your answer was successfully delete.'
  end

  scenario "user tries to delete another's question" do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

  scenario "an unauthorized user tries to delete" do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end
