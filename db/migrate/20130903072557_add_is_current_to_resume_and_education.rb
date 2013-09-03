class AddIsCurrentToResumeAndEducation < ActiveRecord::Migration
  def change
    add_column :resume_items, :is_current, :boolean
    add_column :education_items, :is_current, :boolean
  end
end
