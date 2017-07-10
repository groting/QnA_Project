require_relative '../acceptance_helper.rb'

feature 'Deletes files from answer', %q{
  In order to fix mistake
  As an answer author
  Id like to be able to delete attached files
} do

  given(:user) { create(:user) }
  given(:file) { File.open("#{Rails.root}/spec/spec_helper.rb") }
  given(:question) { create(:question) }
  given(:answer) {create(:answer, question: question, user: user)}
  given(:another_question) { create(:question_with_answers) }

  describe 'User tries to delete file from answer', js: true do

    background do
      sign_in(user)
      answer.attachments.create(file: file)
    end

    scenario 'Author deletes file from question' do
      visit question_path(question)
      within "#answer-#{answer.id}" do
        click_on 'delete file'

        expect(page).to have_no_link 'spec_helper.rb'
      end
    end

    scenario 'User tries to delete file from answer that does not belong to him' do
      visit question_path(another_question)
      within "#answer-#{another_question.answers.first.id}" do
        expect(page).to have_no_link 'delete file'
      end
    end
  end
end