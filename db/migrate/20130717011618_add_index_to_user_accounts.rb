class AddIndexToUserAccounts < ActiveRecord::Migration
  def change
    add_index :user_accounts, [:account_id, :provider], unique: true
  end
end
