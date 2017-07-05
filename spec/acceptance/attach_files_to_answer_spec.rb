require_relative 'acceptance_helper.rb'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answers author
  Id like to be able to attache files
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }

  describe 'User tries to add file to question', js: true do

    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'Answer', with: 'Answer body'
      click_on 'add file'
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
      inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
      click_on 'Create'
    end

    scenario 'User adds file when answers' do
      within ".answers" do
        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
      end
    end

    scenario 'Another user tries to add file to answer' do
      click_on 'Sign out'
      sign_in(another_user)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_no_selector('input')
      end
    end

    scenario 'Unauthenticated user tries to add file to answer' do
      click_on 'Sign out'
      visit question_path(question)

      within '.answers' do
        expect(page).to have_no_selector('input')
      end
    end
  end
end