class MonthsShouldBeIntegers < ActiveRecord::Migration
  def change
    change_column :resume_items, :month_started, :integer
    change_column :resume_items, :month_finished, :integer
    change_column :education_items, :month_started, :integer
    change_column :education_items, :month_finished, :integer
  end
end
