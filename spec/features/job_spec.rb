require 'spec_helper'

feature 'Job setup', js: true do
  scenario 'client searches for programmer and offers job' do
    client_sign_up
    user = FactoryGirl.create(:user_checked_terms, full_name: 'Test Programmer')
    FactoryGirl.create(:programmer, state: :activated, qualified: true, visibility: 'public', user: user)
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
end
