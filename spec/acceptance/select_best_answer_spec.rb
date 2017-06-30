require_relative 'acceptance_helper'

feature 'Select best answer', %q{
  In order to put an evaluation response,
  on the question page
  as an authenticated user
  I need to be able to select the best answer
} do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question_with_answers, user: user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'Author sees link This answer is the answer' do
      within "#answer-#{question.answers.first.id}" do
        expect(page).to have_link 'The best'
      end
    end

    scenario 'Author tries to choose the best answer', js: true do
      within "#answer-#{question.answers.first.id}" do
        click_on 'The best'
        expect(page).to have_content 'best answer'
      end
    end
  end

  scenario 'Another user does not see link This answer is the best' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'The best'
  end

  scenario 'Unauthenticated user tries to choose the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'The best'
  end
end