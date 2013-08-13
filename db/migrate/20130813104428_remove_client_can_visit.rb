class RemoveClientCanVisit < ActiveRecord::Migration
  def change
    remove_column :programmers, :client_can_visit
  end
end
