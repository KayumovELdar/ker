require "rails_helper"

feature "view all questions", %q{
  By going to the main page
  You can view the entire list of questions
  } do

    given(:user){create(:user)}
    given!(:questions){create_list(:question, 5,user: user) }
    scenario 'checking the list of questions' do
      visit questions_path
      questions.each do |question|
        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end
    end
  end
