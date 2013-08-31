class AddStateToProgrammer < ActiveRecord::Migration
  def change
    add_column :programmers, :state, :string
    remove_column :programmers, :disabled
  end
end
