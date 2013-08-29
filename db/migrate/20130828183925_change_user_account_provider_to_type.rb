class ChangeUserAccountProviderToType < ActiveRecord::Migration
  def change
    rename_column :user_accounts, :provider, :type
  end
end
