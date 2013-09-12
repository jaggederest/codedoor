source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use CanCan for authorization
gem 'cancan', '~> 1.6.10'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
# TODO: Use a specific release when there is a release cut with Rails 4 support.
gem 'compass-rails', '~> 2.0.alpha.0'
gem 'bootstrap-sass', '~> 2.3.2.1'

# Use slim for templating
gem 'slim', '~> 2.0.1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 3.0.4'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 1.3.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.5.1'

# GitHub oAuth is used for login, and omniauth is used with devise
gem 'devise', '~> 3.0.1'
gem 'omniauth-github', '~> 1.1.1'

# Manage environment variables related to this application
gem 'figaro', '~> 0.7.0'

gem 'nested_form', '~> 0.3.2'

gem 'github_api', '~> 0.10.1'

gem 'state_machine', '~> 1.2.0'

# Right now, only used for the edge case where there are over 100 contributors
gem 'rest-client', '~> 1.6.7'

group :development, :test do
  gem 'pry'
  gem 'pry-debugger'
  gem 'rspec-rails', '~> 2.14.0'
  gem 'rspec-mocks', '~> 2.14.3'
end

group :test do
  gem 'factory_girl_rails'
  gem 'shoulda'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_cleaner', '~> 1.0.1'
  gem 'launchy'
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', require: false
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
