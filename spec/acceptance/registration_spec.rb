require 'rails_helper'

feature 'User registrates', %q{
  In oder to sign in
  I need to be able to registrate in system
} do

  given(:user) { create(:user) }

  scenario 'Unregistered user tries to registrate' do
    visit root_path
    click_on 'Ask question'
    click_on 'Sign up'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully'
    expect(page).to have_content 'Sign out'
    expect(page).to have_content 'test@test.com'
  end

  scenario 'Authenticated user tries to registrate' do
    sign_in(user)

    visit root_path
    click_on 'Ask question'

    expect(page).to have_no_content 'Sign up'
  end
end
