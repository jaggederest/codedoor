class ChangeTimeStatusToAvailability < ActiveRecord::Migration
  def change
    rename_column :programmers, :time_status, :availability
  end
end
