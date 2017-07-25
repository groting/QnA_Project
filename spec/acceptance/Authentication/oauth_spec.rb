require_relative '../acceptance_helper.rb'

feature 'Authenticate with remote provider', %q{
  In order to log in, user wants to be able to sign in
  with omniauth provider
} do
  background { visit new_user_session_path }

  scenario "Facebook user tries to sign in" do
    mock_auth_facebook
    click_link 'Sign in with Facebook'
    expect(page).to have_content('Successfully authenticated from facebook account')
  end

  scenario "Twitter user tries to sign in" do
    mock_auth_twitter
    click_link 'Sign in with Twitter'
    expect(page).to have_content('Successfully authenticated from twitter account')
  end

  context "User tries to sign in when provider did not send email" do
    scenario "User enters email" do
      mock_auth_without_email
      click_link 'Sign in with Twitter'

      expect(page).to have_content "Twitter did not provide your email, please enter it"
      fill_in 'email', with: 'user@testemail.com'
      click_button 'Save'
      expect(page).to have_content "Could not authenticate you from twitter because
                                    \"you need to confirm email"
    end

    scenario "User leaves email field empty" do
      mock_auth_without_email
      click_link 'Sign in with Twitter'

      expect(page).to have_content "Twitter did not provide your email, please enter it"
      fill_in 'email', with: ''
      click_button 'Save'
      expect(page).to have_content "Twitter did not provide your email, please enter it"
    end
  end
end