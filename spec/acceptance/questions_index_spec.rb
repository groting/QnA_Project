require_relative 'acceptance_helper'

feature 'Questions list', %q{
  In order to find the required answer,
  the user should have the opportunity
  to view the list of questions
} do
  given!(:questions) { create_list(:question, 4) }
  given(:user) { create(:user) }

  scenario 'Authenticated user views list of questions' do
    sign_in(user)
    visit_and_check_question
  end

  scenario 'Unauthenticated user views list of question' do
    visit_and_check_question
  end

  private

  def visit_and_check_question
    visit questions_path

    expect(page).to have_content questions.first.title
    expect(page).to have_content questions.last.title
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end