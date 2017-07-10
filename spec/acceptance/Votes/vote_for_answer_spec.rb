require_relative '../acceptance_helper.rb'

feature 'Vote for answer', %q{
  In order to rate answer
  As an authenticated user
  Id like to be able to vote for answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }


  scenario 'authenticated user set like for answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      choose 'Like'
      click_on 'Vote'
      within "#rate-answer-#{answer.id}" do
        expect(page).to have_content "1"
      end
      expect(page).to have_content "You've liked it"
      expect(page).to have_button 'Recall vote'
    end
  end

  scenario 'authenticated user set dislike to answer', js: true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      choose 'Dislike'
      click_on 'Vote'
      within "#rate-answer-#{answer.id}" do
        expect(page).to have_content "-1"
      end
      expect(page).to have_content "You've disliked it"
      expect(page).to have_button 'Recall vote'
    end
  end

  scenario 'authenticated user tries to vote for answer once more time', js: true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      choose 'Like'
      click_on 'Vote'
      expect(page).to have_no_button 'Vote'
    end
  end

  scenario 'author tries to vote for his answer' do
    sign_in(answer.user)
    visit question_path(question)
    within '.answers' do
      expect(page).to have_no_button 'Vote'
    end
  end

  scenario 'unauthenticated user tries to vote for answer' do
    visit question_path(question)
    within '.answers' do
      expect(page).to have_no_button 'Vote'
    end
  end
end