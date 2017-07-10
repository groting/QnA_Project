require_relative '../acceptance_helper.rb'

feature 'User sign out', %q{
  In oder to finish session
  I need to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user try to sign out' do
    sign_in(user)
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully'
    expect(page).to have_content 'Sign in'
  end

  scenario 'Unauthenticated user try to sign out' do
    visit questions_path

    expect(page).to have_no_content 'Sign out'
  end
end
