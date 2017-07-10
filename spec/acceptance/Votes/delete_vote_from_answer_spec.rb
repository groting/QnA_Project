require_relative '../acceptance_helper.rb'

feature 'Delete vote and re-vote for answer', %q{
  In order to fix mistake
  As an authenticated user
  Id like to be able to delete vote and re-vote for answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:another_user) { create(:user) }

  background do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      choose 'Like'
      click_on 'Vote'
    end
  end

  scenario 'authenticated user delete vote from answer', js: true do
    within '.answers' do
      click_on 'Recall vote'

      within "#rate-answer-#{answer.id}" do
        expect(page).to have_content "0"
      end
      expect(page).to have_no_content "You've liked it"
      expect(page).to have_no_button 'Recall vote'
      expect(page).to have_button 'Vote'
    end
  end
  
  scenario 'anorher user tries to delete vote from answer', js: true do
    click_on 'Sign out'
    sign_in(another_user)
    visit question_path(question)
    within '.answers' do
      expect(page).to have_no_button 'Recall vote'
    end
  end

  scenario 'unauthenticated user tries to delete vote from answer', js: true do
    click_on 'Sign out'
    visit question_path(question)
    within '.answers' do
      expect(page).to have_no_button 'Recall vote'
    end
  end
end