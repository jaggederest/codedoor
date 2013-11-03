require 'spec_helper'

feature 'Job setup', js: true do
  before :each do
    @programmer = FactoryGirl.create(:programmer, :qualified, visibility: 'public', user: FactoryGirl.create(:user_checked_terms, full_name: 'Test Programmer'))
  end

  scenario 'client searches for programmer and offers job' do
    client_sign_up
    click_link 'Search'

    click_link 'Test Programmer'

    click_link 'Contact'

    fill_in 'Job Name', with: 'Test Job'
    find('#job_job_messages_attributes__content').set('Opening message')
    click_button 'Send Message'

    page.should have_content 'Opening message'

    click_link 'Offer Contract'
    page.should have_content 'The job has been offered.'

    job = Job.last
    job.start!

    # Reload the page to finish the job
    click_link 'Jobs'
    click_link 'Test Job'

    click_link 'Finish Job'

    page.should have_content 'Job Finished'
  end

  scenario 'client searched for programmer while logged out' do
    visit '/'
    click_button 'Search'

    click_link 'Test Programmer'

    click_link 'Contact'

    # Contact button requires login, so put into oAuth flow, and then create user page
    page.should have_content 'By checking this box, I agree to abide by CodeDoor\'s'
    check('user_checked_terms')
    select('United States', from: 'user_country')
    select('California', from: 'user_state')
    fill_in 'City', with: 'Burlingame'
    click_button('Create Client Account')

    fill_in 'Company', with: 'Test Company'
    fill_in 'Description', with: 'Test Description'
    click_button 'Add Info'

    # After creating a client, you should be redirect back to the new job flow
    page.should have_content 'Job Name'
    page.should have_content 'Message'
  end
end
