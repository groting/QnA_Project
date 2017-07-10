require_relative '../acceptance_helper.rb'

feature 'Deletes files from question', %q{
  In order to fix mistake
  As an questions author
  Id like to be able to delete attached files
} do

  given(:user) { create(:user) }
  given(:file) { File.open("#{Rails.root}/spec/spec_helper.rb") }
  given(:question) { create(:question, user: user) }
  given(:another_question) { create(:question) }

  describe 'User tries to delete file from question', js: true do
    
    background do
      sign_in(user)
      question.attachments.create(file: file)
    end

    scenario 'Author deletes file from question' do
      visit question_path(question)
      within '.question-attachments' do
        click_on 'delete file'

        expect(page).to have_no_link 'spec_helper.rb'
      end
    end

    scenario 'User tries to delete file from question that does not belong to him' do
      visit question_path(another_question)
      within '.question-attachments' do
        expect(page).to have_no_link 'delete file'
      end
    end
  end
end