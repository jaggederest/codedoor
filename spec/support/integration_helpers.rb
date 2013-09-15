require 'spec_helper'

module FeatureTestHelper
  module SignIn
    def github_login(stub_out_calls = true)
      GithubUserAccount.any_instance.stub(:load_repos).and_return([]) if stub_out_calls
      visit '/'
      click_link 'Log in with GitHub'
    end

    def programmer_sign_up
      github_login
      click_link 'Edit user account'
      page.should have_content 'By checking this box, I agree to abide by CodeDoor\'s Terms of Use.'
      check('user_checked_terms')
      select('United States', from: 'user_country')
      select('California', from: 'user_state')
      fill_in 'City', with: 'Burlingame'
      click_button 'Create Programmer Account'

      fill_in 'Title', with: 'Test Title'
      fill_in 'Description', with: 'Test Description'
      fill_in 'hourly_rate_to_programmer', with: 100

      page.should have_content('As a full-time programmer, billing is generally done a daily basis. The hourly rate is used when you spend an hour or two with a client.')

      find('#hourly_rate_to_programmer').trigger('blur')
      page.should have_content('$800/day')

      choose('Part-time')

      page.should_not have_content('As a full-time programmer, billing is generally done a daily basis. The hourly rate is used when you spend an hour or two with a client.')
      page.should_not have_content('$800/day')

      choose('Full-time')
      choose('programmer_onsite_status_onsite')
      click_button 'Add Info'
    end

    def go_to_programmer_settings
      click_link 'Settings'
      click_link 'Programmer Info'
    end

    def set_github_user
      OmniAuth.config.mock_auth[:github] = MockGitHubAuth.test_user
    end

    # TODO: Calling this method shouldn't call log spew in test
    def github_logins_fail
      OmniAuth.config.mock_auth[:github] = :invalid_credentials

      yield

      set_github_user
    end
  end
end

RSpec.configure do |config|
  config.include FeatureTestHelper::SignIn, type: :feature
end
