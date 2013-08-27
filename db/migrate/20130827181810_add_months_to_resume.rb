class AddMonthsToResume < ActiveRecord::Migration
  def change
    add_column :resume_items, :month_started, :string
    add_column :resume_items, :month_finished, :string
  end
end
