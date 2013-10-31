class EncryptOauthTokens < ActiveRecord::Migration
  def change
    add_column :user_accounts, :encrypted_oauth_token, :string
    add_column :user_accounts, :encrypted_oauth_token_salt, :string
    add_column :user_accounts, :encrypted_oauth_token_iv, :string
    # NOTE: It is actually non-trivial to migrate to attr_encryptor, so I am simply not doing it,
    # because I'm the only active developer, and there is no active data.
    remove_column :user_accounts, :oauth_token, :string
  end
end
