class CreateUserAccounts < ActiveRecord::Migration
  def change
    create_table :user_accounts do |t|
      t.integer :user_id
      t.string :provider

      t.timestamps
    end
  end
end
