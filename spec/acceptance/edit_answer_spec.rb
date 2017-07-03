require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  as an author of answer
  I'd like to be able to edit answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unuthenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  context 'Authenticated user' do

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to edit his answer', js: true do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    let(:another_user) { create(:user) }

    scenario "tries to edit other user's answer", js: true do
      click_on 'Sign out'
      sign_in(another_user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end