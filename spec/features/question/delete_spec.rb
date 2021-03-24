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
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    click_on 'Удалить вопрос'

    expect(page).not_to have_content question.title
    expect(page).not_to have_content question.body

  end

  scenario "author delete file" do
    sign_in(author)
    visit question_path(question)
    within '.questions' do
      click_on 'Обновить'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Сохранить'
    end
    within("#file-#{question.files.first.id}") { click_on 'Удалить файл вопроса' }
    expect(page).to_not have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end

  scenario "user tries to delete another's question" do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Удалить вопрос'
  end

  scenario 'an unauthorized user tries to delete' do
    visit question_path(question)

    expect(page).to_not have_link 'Удалить вопрос'
  end
end
