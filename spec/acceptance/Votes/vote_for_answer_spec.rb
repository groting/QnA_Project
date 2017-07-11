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
      click_on 'Like'
      within "#rate-answer-#{answer.id}" do
        expect(page).to have_content "1"
      end
      expect(page).to have_link 'Recall vote'
    end
  end

  scenario 'authenticated user set dislike to answer', js: true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      click_on 'Dislike'
      within "#rate-answer-#{answer.id}" do
        expect(page).to have_content "-1"
      end
      expect(page).to have_link 'Recall vote'
    end
  end

  scenario 'authenticated user tries to vote for answer once more time', js: true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      click_on 'Like'
      expect(page).to have_no_link 'Like'
    end
  end

  scenario 'author tries to vote for his answer' do
    sign_in(answer.user)
    visit question_path(question)
    within '.answers' do
      expect(page).to have_no_link 'Like'
    end
  end

  scenario 'unauthenticated user tries to vote for answer' do
    visit question_path(question)
    within '.answers' do
      expect(page).to have_no_link 'Like'
    end
  end
end