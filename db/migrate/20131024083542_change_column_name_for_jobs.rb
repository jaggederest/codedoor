class ChangeColumnNameForJobs < ActiveRecord::Migration
  def change
    rename_column :job_messages, :project_id, :job_id
  end
end
