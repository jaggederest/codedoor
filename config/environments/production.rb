require Rails.root.join('config/environments/shared_production')

Codedoor::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.action_mailer.default_url_options = { host: 'codedoor.com' }

  GA.tracker = ENV['GOOGLE_ANALYTICS_TRACKER']

end
