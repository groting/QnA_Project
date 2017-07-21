require_relative '../acceptance_helper.rb'

feature 'Create answer', %q{
  In order to answer to question
  beign on the question page,
  as an authenticated user
  I need to be able to create answer
} do

  given!(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:users_question) { create(:question, user: user) }
  given(:another_user) { create(:user) }

  scenario 'Authenticated user answers the question', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'answer_body', with: 'Answer text'
    click_on 'Create answer'

    expect(page).to have_content 'Answer text'
  end
  
  scenario 'Unauthenticated user answers the question' do
    visit question_path(question)
    expect(page).to have_no_content 'Create answer'
  end

  scenario 'Authenticated user tries to create answer with blank body field', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Create answer'

    expect(page).to have_content "Body can't be blank"
  end

  context 'multiple sessions' do

    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'answer_body', with: 'Answer text'
        click_on 'Create answer'

        expect(page).to have_content 'Answer text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Answer text'
      end
    end
  end
end