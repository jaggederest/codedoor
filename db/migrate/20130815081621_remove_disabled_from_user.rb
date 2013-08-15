class RemoveDisabledFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :disabled
  end
end
