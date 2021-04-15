require 'rails_helper'
feature 'User can vote for answer', %q{
  In order to show that I like this answer
  As not an author of this answer
  I'd like to be able to like this answer
} do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Unauthenticated user can not like answer' do
    visit question_path(question)

    expect(page).to_not have_link 'vote for'
    expect(page).to_not have_link 'vote against'
  end

  describe 'Authenticated user can like answer', js: true do
    scenario 'Author of answer can not like his answer' do
      sign_in_and_visit(author)

      expect(page).to_not have_link 'vote for'
      expect(page).to_not have_link 'vote against'
    end

    scenario 'Not an author can like other answer' do
      sign_in_and_visit(user)

      within '.answers' do
        click_on 'vote for'

        expect(page).to have_content "Rating: 1"

      end
    end
  end

  private

  def sign_in_and_visit(user)
    sign_in(user)
    visit question_path(question)
  end
end
