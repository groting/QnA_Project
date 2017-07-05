require_relative 'acceptance_helper.rb'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an questions author
  Id like to be able to attache files
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'User tries to add file to question', js: true do

    background do
      sign_in(user)
      visit new_question_path
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Question body'
      click_on 'add file'
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
      inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
      click_on 'Create'
    end
    
    scenario 'Author adds file when asks question' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end

    scenario 'Another user tries to add file to question' do
      click_on 'Sign out'
      sign_in(another_user)
      visit question_path(Question.last)

      within '.question' do
        expect(page).to have_no_selector('input')
      end
    end

    scenario 'Unauthenticated user tries to add file to question' do
      click_on 'Sign out'
      visit question_path(Question.last)

      within '.question' do
        expect(page).to have_no_selector('input')
      end
    end
  end
end