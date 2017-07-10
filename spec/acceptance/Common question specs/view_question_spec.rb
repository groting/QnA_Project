require_relative '../acceptance_helper.rb'

feature 'View question', %q{
  In order to find an answer to question
  I need to be able to view question
  and answers to that question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers) }

  scenario 'Authenticated user views the question and answers to that question' do
    sign_in(user)
    visit_and_check_question
  end
  scenario 'Unauthenticated user views the questions and answers to that question' do
    visit_and_check_question
  end

  private

  def visit_and_check_question
    visit question_path(question)

    expect(page).to have_content 'QuestionTitle'
    expect(page).to have_content 'QuestionBody'
    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end

  end
end
