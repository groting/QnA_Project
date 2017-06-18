require 'rails_helper'

feature 'Author deletes answer', %q{
  Author can delete his answer
  but could not delete someone else's answer
} do

  given(:user) { create(:user) }
  given(:user_with_answers) { create(:user_with_answers) }
  given(:answer) { create(:answer) }

  scenario 'Author tries to delete his answer' do
    sign_in(user_with_answers)

    visit question_path(user_with_answers.answers.first.question)
    click_on 'Delete answer'

    expect(page).to have_content 'Your answer successfully deleted'
    expect(page).to have_no_content answer.body
  end

  scenario 'Author tries to delete answer that does not belongs to him' do
    sign_in(user)

    visit question_path(user_with_answers.answers.first.question)
    expect(page).to have_no_content 'Delete answer'
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(answer.question)

    expect(page).to have_no_content 'Delete answer'
  end
end