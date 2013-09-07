# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
unless Rails.env.production?
  ENV['RAILS_SECRET_KEY_BASE'] = '11c6b8ece23429bcec6d95d311b20653ed641d46736ef3a01df487ee236a72da6e79035e480342562843f2db57f54b267c8f2d95dd6a69bbd6535cad7384c771'
end
Codedoor::Application.config.secret_key_base = ENV['RAILS_SECRET_KEY_BASE']
