class AddUsernameToUserAccount < ActiveRecord::Migration
  def change
    add_column :user_accounts, :username, :string
  end
end
