require_relative '../acceptance_helper'

feature 'Create comment', %q{
  In order to clarify the issue,
  the user can create comments to question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_user) { create(:user) }

  scenario 'authorized user tries to create comment to quesiton', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question-comments' do
      fill_in 'Comment body', with: 'Text text'
      click_on 'Save comment'

      expect(page).to have_content 'Text text'
    end
  end

  scenario "unauthorized user tries to create comment to question", js: true do
    visit question_path(question)
    within '.question-comments' do
      expect(page).to have_no_field('Comment body')
      expect(page).to have_no_button 'Save comment'
    end
  end


  context 'multiple sessions' do
    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('another_user') do
        sign_in(another_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.comments' do
          click_on 'New comment'
          fill_in 'Comment body', with: 'Comment text'
          click_on 'Save comment'

          expect(page).to have_content 'Comment text'
        end
      end

      Capybara.using_session('another_user') do
        expect(page).to have_content 'Comment text'
      end
    end

    scenario "comment appears on guest's page", js: true do

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.comments' do
          click_on 'New comment'
          fill_in 'Comment body', with: 'Comment text'
          click_on 'Save comment'

          expect(page).to have_content 'Comment text'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Comment text'
      end
    end
  end

  context 'Guest' do
    scenario 'tries to create comment to question' do
      visit question_path(question)
      within '.comments' do
        expect(page).to have_no_link 'New comment'
      end
    end
  end
end