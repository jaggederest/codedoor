require 'spec_helper'

feature 'Logging in' do
  scenario 'Successful log in' do
    visit '/'
    expect(page).to have_content 'Sign in with GitHub'
    expect(page).to have_content 'Logged out'
    click_link 'Sign in with GitHub'
    expect(page).to have_content 'Logged in'
    expect(page).to have_content 'Test User'
  end

  scenario 'Failed log in' do
    visit '/'
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    click_link 'Sign in with GitHub'
    save_and_open_page
    expect(page).to have_content 'Logged out'
    expect(page).not_to have_content 'Test User'
  end
end
