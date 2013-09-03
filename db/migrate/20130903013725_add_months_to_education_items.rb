class AddMonthsToEducationItems < ActiveRecord::Migration
  def change
    add_column :education_items, :month_started, :string
    add_column :education_items, :month_finished, :string
  end
end
