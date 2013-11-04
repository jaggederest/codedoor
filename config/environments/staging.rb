require Rails.root.join('config/environments/shared_production')

Codedoor::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.action_mailer.default_url_options = { host: 'stealthcodedoor.herokuapp.com' }

  # Raise errors for failed emails
  config.action_mailer.raise_delivery_errors = false
end
