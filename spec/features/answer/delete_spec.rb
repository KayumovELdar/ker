require 'rails_helper'

feature 'user can delete his answer', "
  for the sake of order
  as an authenticated user
  i'd like to be able to delete only my own answers
" do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }

  scenario 'author deletes his answer', js: true do
    sign_in(answer.user)
    visit question_path answer.question

    expect(page).to have_content answer.body

    click_on 'Удалить'

    expect(page).not_to have_content answer.body
  end

  scenario "user tries to delete another's question", js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Удалить'
  end

  scenario 'an unauthorized user tries to delete' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end
