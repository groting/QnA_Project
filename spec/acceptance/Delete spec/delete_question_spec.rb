require_relative '../acceptance_helper.rb'

feature 'Author deletes question', %q{
  Author can delete his question
  but could not delete someone else's question
} do

  given(:user) { create(:user) }
  given(:user_with_questions) { create(:user_with_questions) }
  given(:question) { create(:question) }

  scenario 'Author tries to delete his question' do
    sign_in(user_with_questions)

    visit question_path(user_with_questions.questions.first)
    click_on 'Delete question'

    expect(page).to have_content 'Your question successfully deleted'
    expect(page).to have_no_content question.title
  end

  scenario 'Author tries to delete question that does not belongs to him' do
    sign_in(user)

    visit question_path(user_with_questions.questions.first)
    expect(page).to have_no_content 'Delete question'
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(question)

    expect(page).to have_no_content 'Delete question'
  end
end
