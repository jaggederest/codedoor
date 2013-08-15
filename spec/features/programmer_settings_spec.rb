require 'spec_helper'

feature 'Logging in' do
  scenario 'programmer sign up and editing' do
    github_login
    click_link 'Edit user account'
    expect(page).to have_content 'By checking this box, I agree to abide by CodeDoor\'s Terms of Use.'
    check('user_checked_terms')
    select('United States')
    click_button 'Create Programmer Account'

    fill_in 'Title', with: 'Test Title'
    fill_in 'Description', with: 'Test Description'
    fill_in 'Rate', with: 100
    choose('Full-time')
    choose('programmer_onsite_status_onsite')
    click_button 'Add Info'

    expect(page).to have_content 'Your programmer account has been created.'
    expect(page).to have_content 'Test User'
    expect(page).to have_content 'Test Title'
    expect(page).to have_content '$900 per day'
    expect(page).to have_content 'Full Time'
    expect(page).to have_content 'Work can be done at a client\'s office if it is nearby.'

    click_link 'Edit Basic Info'
    expect(page).not_to have_content 'By checking this box, I agree to abide by CodeDoor\'s Terms of Use.'
    click_button 'Edit Info'

    fill_in 'Rate', with: 50
    click_button 'Edit Info'
    expect(page).to have_content 'Your programmer account has been updated.'
    expect(page).to have_content '$450 per day'
  end
end
