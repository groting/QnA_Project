require_relative '../acceptance_helper.rb'

feature 'Create question', %q{
  In order to get answers form community
  as an authenticated user
  I need to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user create question' do
    sign_in(user)

    click_ask_question_link
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Some Text'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created'
    expect(page).to have_content 'Question title'
    expect(page).to have_content 'Some Text'
  end

  scenario 'Authenticated user tries to create question with blank fields' do
    sign_in(user)

    click_ask_question_link
    click_on 'Create'

    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Unauthenticated user create question' do
    click_ask_question_link
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end

  context 'multiple sessions' do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_ask_question_link
        fill_in 'Title', with: 'Question title'
        fill_in 'Body', with: 'Some Text'
        click_on 'Create'

        expect(page).to have_content 'Your question successfully created'
        expect(page).to have_content 'Question title'
        expect(page).to have_content 'Some Text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Question title'
      end
    end
end

   private

  def click_ask_question_link
    visit questions_path
    click_on 'Ask question'
  end
end