require 'spec_helper'

feature 'Logging in' do
  scenario 'Successful log in' do
    visit '/'
    expect(page).to have_content 'Log in with GitHub'
    expect(page).to have_content 'Work for clients that appreciate top developers that contribute to open source. Daily billing.'
    expect(page).to have_content 'Find programmers that have contributed to meaningful open source projects, and see their code samples.'
    click_link 'Log in with GitHub'
    expect(page).to have_content 'Logged in'
  end

  scenario 'Failed log in' do
    github_logins_fail do
      visit '/'
      click_link 'Log in with GitHub'
      expect(page).to have_content 'Log in with GitHub'
      expect(page).not_to have_content 'Logged in'
    end
  end
end
