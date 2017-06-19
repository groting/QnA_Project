require 'rails_helper'

feature 'Create answer', %q{
  In order to answer to question
  beign on the question page,
  as an authenticated user
  I need to be able to create answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user answers the question' do
    sign_in(user)
    visit question_path(question)
    fill_in 'answer_body', with: 'Answer text'
    click_on 'Create answer'

    expect(page).to have_content 'Answer text'
    expect(page).to have_content 'Your answer successfully created'
  end

  scenario 'Authenticated user tries to create answer with blank body field' do
    sign_in(user)
    visit question_path(question)
    click_on 'Create answer'

    expect(page).to have_content "Body can't be blank"
  end
  
  scenario 'Unauthenticated user answers the question' do
    visit question_path(question)
    expect(page).to have_no_content 'Create answer'
  end
end