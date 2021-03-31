require 'rails_helper'

feature 'User can his answer', %q{
  In order to correct mistakes
  as an author of anser
  I'd like to be able to edit my answer
} do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }

  scenario 'Unauthenticated user can not edit answers' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do

    context 'edits his answer' do

      before do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'without errors' do
        click_on 'Обновить'

        within '.answers' do
          fill_in :answer_body, with: 'edited answer'
          click_on 'Сохранить'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits his answer whitn attached files' do
        expect(page).to_not have_link 'rails_helper.rb'
        expect(page).to_not have_link 'spec_helper.rb'

        within '.answers' do
          click_on 'Обновить'
          attach_file 'File',["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Сохранить'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
        click_on question.title

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'with deleting link' do

        answer.links.build( linkable: question, name: "youtube_link", url: "https://www.youtube.com/")
        answer.save
        answer.reload

        visit question_path(question)

        within '.answer-links' do
          click_button 'Delete link'

          expect(page).to_not have_link "youtube_link"
        end
      end

      scenario 'with errors' do
        click_on 'Обновить'

        within '.answers' do
          fill_in :answer_body, with: ''
          click_on 'Сохранить'

          expect(page).to have_content "Body can't be blank"
        end
      end
    end



    scenario "tries to edit either user's answer" do
      sign_in(user)
      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end
  end
end
