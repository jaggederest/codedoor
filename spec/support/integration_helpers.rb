require 'spec_helper'

module FeatureTestHelper
  module SignIn
    def github_login(stub_out_calls = true)
      GithubUserAccount.any_instance.stub(:load_repos).and_return([]) if stub_out_calls
      visit '/'
      click_link 'Log in with GitHub'
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
