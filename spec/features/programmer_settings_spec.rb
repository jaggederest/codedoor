require 'spec_helper'

def test_programmer_sign_up_and_editing(test_js)
  github_login
  click_link 'Edit user account'
  page.should have_content 'By checking this box, I agree to abide by CodeDoor\'s Terms of Use.'
  check('user_checked_terms')
  select('United States')
  click_button 'Create Programmer Account'

  fill_in 'Title', with: 'Test Title'
  fill_in 'Description', with: 'Test Description'
  fill_in 'hourly_rate_to_programmer', with: 100

  page.should have_content('As a full-time programmer, billing is generally done a daily basis. The hourly rate is used when you spend an hour or two with a client.')

  if (test_js)
    find('#hourly_rate_to_programmer').trigger('blur')
    page.should have_content('$800/day')

    choose('Part-time')

    page.should_not have_content('As a full-time programmer, billing is generally done a daily basis. The hourly rate is used when you spend an hour or two with a client.')
    page.should_not have_content('$800/day')
  end

  choose('Full-time')
  choose('programmer_onsite_status_onsite')
  click_button 'Add Info'

  page.should have_content 'Your programmer account has been created.'
  page.should have_content 'Test User'
  page.should have_content 'Test Title'
  page.should have_content '$900 per day'
  page.should have_content 'Full Time'
  page.should have_content 'Work can be done at a client\'s office if it is nearby.'

  click_link 'Edit Basic Info'
  page.should_not have_content 'By checking this box, I agree to abide by CodeDoor\'s Terms of Use.'
  click_button 'Edit Info'

  fill_in 'hourly_rate_to_programmer', with: 50
  click_button 'Edit Info'
  page.should have_content 'Your programmer account has been updated.'
  page.should have_content '$450 per day'
end

feature 'Logging in', js: true do
  scenario 'programmer sign up and editing' do
    test_programmer_sign_up_and_editing(true)
  end
end

feature 'Logging in without JavaScript' do
  scenario 'programmer sign up and editing' do
    test_programmer_sign_up_and_editing(false)
  end
end
