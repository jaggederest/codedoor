class AddVisibilityAndDisabledToProgrammers < ActiveRecord::Migration
  def change
    add_column :programmers, :visibility, :string
    add_column :programmers, :disabled, :boolean
  end
end
