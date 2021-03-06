require_relative '../acceptance_helper.rb'

feature 'Delete vote and re-vote for question', %q{
  In order to fix mistake
  As an authenticated user
  Id like to be able to delete vote and re-vote for question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:another_user) { create(:user) }

  background do
    question.like(user)
  end

  scenario 'authenticated user delete vote from question', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question' do
      click_on 'Recall vote'
      within "#rate-question-#{question.id}" do
        expect(page).to have_content "0"
      end
      expect(page).to have_no_link 'Recall vote'
      expect(page).to have_link 'Dislike'
    end
  end

  scenario 'anorher user tries to delete vote from question', js: true do
    sign_in(another_user)
    visit question_path(question)
    within '.question' do
      expect(page).to have_no_link 'Recall vote'
    end
  end

  scenario 'unauthenticated user tries to delete vote from question', js: true do
    visit question_path(question)
    within '.question' do
      expect(page).to have_no_link 'Recall vote'
    end
  end
end