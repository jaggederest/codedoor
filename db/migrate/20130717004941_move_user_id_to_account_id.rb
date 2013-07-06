class MoveUserIdToAccountId < ActiveRecord::Migration
  def change
    rename_column :user_accounts, :user_id, :account_id
  end
end
