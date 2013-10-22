class ChangeProjectsToJobs < ActiveRecord::Migration
  def change
    rename_table :projects, :jobs
    rename_table :project_messages, :job_messages
  end
end
