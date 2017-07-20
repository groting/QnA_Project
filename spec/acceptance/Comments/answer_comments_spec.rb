require_relative '../acceptance_helper'

feature 'Create comment', %q{
  In order to clarify the answer,
  the user can create comments to answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:another_user) { create(:user) }

  context 'Authenticated user' do
    scenario 'tries to create comment to his answer', js: true do
      sign_in(user)
      visit question_path(question)
      within "#answer-#{answer.id}" do
        fill_in 'Comment body', with: 'Text text'
        click_on 'Save comment'

        expect(page).to have_content 'Text text'
      end
    end

    scenario "tries to create comment to another user's answer", js: true do
      sign_in(another_user)
      visit question_path(question)

      within "#answer-#{answer.id}" do
        fill_in 'Comment body', with: 'Text text'
        click_on 'Save comment'

        expect(page).to have_content 'Text text'
      end
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
        within "#answer-#{answer.id}" do
          click_on 'New comment'
          fill_in 'Comment body', with: 'Text text'
          click_on 'Save comment'
        end
      end

      Capybara.using_session('another_user') do
        visit question_path(question)

        within "#answer-#{answer.id}" do
          expect(page).to have_content 'Text text'
        end
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
        within "#answer-#{answer.id}" do
          click_on 'New comment'
          fill_in 'Comment body', with: 'Text text'
          click_on 'Save comment'
        end
      end

      Capybara.using_session('guest') do
        visit question_path(question)

        within "#answer-#{answer.id}" do
          expect(page).to have_content 'Text text'
        end
      end
    end
  end

  context 'Guest' do
    scenario 'tries to create comment to answer' do
      visit question_path(question)
      expect(page).to have_no_link 'New comment'
    end
  end
end