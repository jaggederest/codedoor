require 'spec_helper'

module FeatureTestHelper
  module SignIn
    def github_login
      visit '/'
      click_link 'Log in with GitHub'
    end

    # TODO: DRY with setting variable in spec_helper.rb
    def set_github_user
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
        {uid: 'test account id',
         provider: 'github',
         credentials: {token: 'oauth token'},
         info: {email: 'email@example.com'},
         extra: {raw_info: {name: 'Test User'}}})
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
