require_relative '../acceptance_helper.rb'

feature 'Question editing', %q{
  In order to fix mistake
  as an author of question
  I'd like to be able to edit question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unuthenticated user tries to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees question edit link' do
      within '.question' do
        expect(page).to have_link 'Edit question'
      end
    end

    scenario 'tries to edit his question', js: true do
      
      within '.question' do
        click_on 'Edit question'
        fill_in 'question_title', with: 'edited question title'
        fill_in 'Question body', with: 'edited question body'
        click_on 'Save question'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_selector 'text_field'
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_link 'Edit question'
      end

      within '.panel-heading' do
        expect(page).to_not have_content question.title
        expect(page).to have_content 'edited question title'
      end
    end

    let(:another_user) { create(:user) }

    scenario "tries to edit other user's question", js: true do
      click_on 'Sign out'
      sign_in(another_user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end