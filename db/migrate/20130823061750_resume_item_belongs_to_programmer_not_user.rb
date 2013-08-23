class ResumeItemBelongsToProgrammerNotUser < ActiveRecord::Migration
  def change
    rename_column :resume_items, :user_id, :programmer_id
  end
end
