class AddCalculatedAvailability < ActiveRecord::Migration
  def change
    add_column :programmers, :calculated_availability, :string
  end
end
