require 'spec_helper'

feature 'Logging in' do
  scenario 'Successful log in and log out' do
    visit '/'
    page.should have_content 'Log in with GitHub'
    page.should have_content 'Work for clients who recognize top open source contributors.'
    page.should have_content 'Bill by the day.'

    page.should have_content 'Find freelance coders who have contributed to meaningful projects.'
    page.should have_content 'See their code before hiring.'

    click_link 'Log in with GitHub'
    page.should have_content 'Log out'

    click_link 'Log out'
    page.should have_content 'Log in with GitHub'
  end

  scenario 'Failed log in' do
    github_logins_fail do
      visit '/'
      click_link 'Log in with GitHub'
      page.should have_content 'Log in with GitHub'
      page.should_not have_content 'Logged in'
    end
  end
end
