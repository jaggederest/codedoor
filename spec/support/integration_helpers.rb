require 'spec_helper'

module FeatureTestHelper
  module SignIn
    def github_login
      visit '/'
      click_link 'Sign in with GitHub'
    end
  end
end

RSpec.configure do |config|
  config.include FeatureTestHelper::SignIn, type: :feature
end
