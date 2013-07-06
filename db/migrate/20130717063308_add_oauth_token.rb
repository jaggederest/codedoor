class AddOauthToken < ActiveRecord::Migration
  def change
    add_column :user_accounts, :oauth_token, :string
  end
end
