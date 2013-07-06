class MigrateAccountIdToString < ActiveRecord::Migration
  def change
    change_column :user_accounts, :account_id, :string
  end
end
