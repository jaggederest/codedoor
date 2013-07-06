class AddUserIdToUserAccounts < ActiveRecord::Migration
  def change
    add_column :user_accounts, :user_id, :integer
  end
end
