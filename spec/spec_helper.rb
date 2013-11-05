require 'simplecov'
SimpleCov.start 'rails'
# Comment the following two lines if you want to check the test coverage of your local copy
require 'coveralls'
Coveralls.wear!

require 'fakeweb'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'cancan/matchers'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  Capybara.javascript_driver = :poltergeist
  Capybara.default_wait_time = 5

  config.use_transactional_examples = false
  config.use_transactional_fixtures = false
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
    DbUpdate.update_skills
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

class MockGitHubAuth
  def self.test_user
    OmniAuth::AuthHash.new(
      {provider: "github",
       uid: '1234567',
       credentials: {token: 'oauth token'},
       info: {email: 'email@example.com', nickname: 'test-username'},
       extra: {raw_info: {name: 'Test User'}}})
  end
end

OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:github] = MockGitHubAuth.test_user

class FakeWebHelpers
  def self.mock_rails_repo_request
    FakeWeb.register_uri(:get, 'https://api.github.com/repos/rails/rails?access_token=hats', :body => '{
    "default_branch": "",
    "forks_count": "0",
    "watchers_count": "50",
    "language": "ruby",
    "fork": "false",
    "name": "rails",
    "owner": {
        "login": "rails"
    },
    "description": ""
}')
  end

  def self.mock_scrape_rails_contributor(username)
    FakeWeb.register_uri(:get, 'https://github.com/rails/rails/commits?author=' + username, :body => 'Browse code')
  end
  def self.mock_scrape_rails_noncontributor(username)
    FakeWeb.register_uri(:get, 'https://github.com/rails/rails/commits?author=' + username, :body => 'Browse code No commits found')
  end

  def self.mock_api_large_repo(token)
    # this just needs to be a json response with 100 objects in it to
    # trigger the 'repo too large, drop back to html scrape' logic
    FakeWeb.register_uri(:get, 'https://api.github.com/repos/rails/rails/contributors?access_token='+token, :body => "[#{(['{}']*100).join(',')}]")
  end

  def self.mock_missing_repo(token)
    FakeWeb.register_uri(:get, 'https://api.github.com/repos/rhc2104/repo-that-does-not-exist/contributors?access_token='+token, :status => ['404', 'Not Found'])
  end
end
