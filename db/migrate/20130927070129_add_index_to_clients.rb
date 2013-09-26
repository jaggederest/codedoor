class AddIndexToClients < ActiveRecord::Migration
  def change
    add_index :clients, :user_id
  end
end
