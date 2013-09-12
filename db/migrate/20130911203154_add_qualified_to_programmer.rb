class AddQualifiedToProgrammer < ActiveRecord::Migration
  def change
    add_column :programmers, :qualified, :boolean
  end
end
