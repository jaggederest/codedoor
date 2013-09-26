require 'spec_helper'

module FeatureTestHelper
  module SignIn
    def github_login(stub_out_calls = true)
      GithubUserAccount.any_instance.stub(:load_repos).and_return([]) if stub_out_calls
      visit '/'
      click_link 'Log in with GitHub'
    end

    def user_sign_up(programmer = true)
      github_login
      page.should have_content 'By checking this box, I agree to abide by CodeDoor\'s'
      check('user_checked_terms')
      select('United States', from: 'user_country')
      select('California', from: 'user_state')
      fill_in 'City', with: 'Burlingame'
      click_button(programmer ? 'Create Programmer Account' : 'Create Client Account')
    end

    def client_sign_up
      user_sign_up(false)

      fill_in 'Company', with: 'Test Company'
      fill_in 'Description', with: 'Test Description'
      click_button 'Add Info'
    end

    def programmer_sign_up
      user_sign_up

      fill_in 'Title', with: 'Test Title'
      fill_in 'Description', with: 'Test Description'
      fill_in 'hourly_rate_to_programmer', with: 100

      choose('Full-time')
      choose('programmer_onsite_status_onsite')
      click_button 'Add Info'
    end

    def go_to_client_settings
      click_link 'Settings'
      click_link 'Client Info'
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
